import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/constants/media_constants.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/errors/run_local.dart';
import 'package:hairextensions/core/media/image_permission_denied_exception.dart';
import 'package:hairextensions/core/media/image_source_picker.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/core/sync/sync_queue.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';
import 'package:hairextensions/features/business_setup/domain/repositories/business_profile_repository.dart';
import 'package:injectable/injectable.dart';

/// Local first: sqflite is the source of truth and every save is queued for
/// the server. Works fully offline and in the mock environment.
@LazySingleton(as: BusinessProfileRepository)
class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  BusinessProfileRepositoryImpl(
    this._local,
    this._logos,
    this._picker,
    this._syncQueue,
    this._session,
    this._clock,
  );

  static const String _source = 'BusinessProfileRepository';
  static const String _singletonEntityId = '${BusinessProfileTable.singletonId}';

  final BusinessProfileLocalDataSource _local;
  final LogoFileStore _logos;
  final ImageSourcePicker _picker;
  final SyncQueue _syncQueue;
  final AppSession _session;
  final Clock _clock;

  @override
  Future<Either<Failure, BusinessProfile?>> getProfile() {
    return runLocal(_source, () async {
      final model = await _local.read();
      return model == null ? null : BusinessProfileMapper.toEntity(model);
    });
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(BusinessProfile profile, {required bool completeSetup}) {
    return runLocal(_source, () async {
      final existing = await _local.read();
      final now = _clock.now().millisecondsSinceEpoch;
      final model = BusinessProfileMapper.toModel(
        profile,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );
      await _local.upsert(model);
      await _syncQueue.enqueue(
        entity: BusinessProfileTable.name,
        entityId: _singletonEntityId,
        type: existing == null ? SyncOperationType.create : SyncOperationType.update,
        payload: model.toJson(),
      );
      if (completeSetup) {
        await _session.markSetupCompleted();
      }
      final previousLogo = existing?.logoPath;
      if (previousLogo != null && previousLogo != profile.logoPath) {
        await _logos.delete(previousLogo);
      }
      return unit;
    });
  }

  @override
  Future<Either<Failure, String?>> pickLogo() async {
    final String? picked;
    try {
      picked = await _picker.pickFromGallery(
        maxDimension: MediaConstants.logoMaxDimension,
        imageQuality: MediaConstants.logoImageQuality,
      );
    } on ImagePermissionDeniedException {
      return const Left(PermissionDeniedFailure(isPermanent: true));
    } on Object {
      return const Left(UnknownFailure());
    }
    if (picked == null) {
      return const Right(null);
    }
    return runLocal(_source, () => _logos.store(picked!));
  }
}
