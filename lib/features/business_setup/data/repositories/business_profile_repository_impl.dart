import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/constants/media_constants.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/errors/run_local.dart';
import 'package:hairextensions/core/media/image_permission_denied_exception.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/media/image_source_picker.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/sync/sync_queue.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';
import 'package:hairextensions/features/business_setup/domain/repositories/business_profile_repository.dart';
import 'package:injectable/injectable.dart';

/// Signup steps keep a local draft. Completing setup and editing settings
/// require server acknowledgement before reporting success.
@LazySingleton(as: BusinessProfileRepository)
class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  BusinessProfileRepositoryImpl(
    this._local,
    this._logos,
    this._picker,
    SyncQueue syncQueue,
    this._session,
    this._clock,
    this._remote,
  );

  static const String _source = 'BusinessProfileRepository';

  final BusinessProfileLocalDataSource _local;
  final LogoFileStore _logos;
  final ImageSourcePicker _picker;
  final AppSession _session;
  final Clock _clock;
  final BusinessProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, BusinessProfile?>> getProfile() {
    return runLocal(_source, () async {
      final model = await _local.read();
      return model == null ? null : BusinessProfileMapper.toEntity(model);
    });
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(
    BusinessProfile profile, {
    required bool completeSetup,
  }) async {
    final saved = await runLocal(_source, () async {
      final existing = await _local.read();
      final now = _clock.now().millisecondsSinceEpoch;
      final model = BusinessProfileMapper.toModel(
        profile,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );
      await _local.upsert(model);
      final previousLogo = existing?.logoPath;
      if (previousLogo != null && previousLogo != profile.logoPath) {
        await _logos.delete(previousLogo);
      }
      return model;
    });
    if (saved.isLeft()) {
      return saved.map((_) => unit);
    }
    // Intermediate signup steps stay a local draft until the final setup step.
    if (!completeSetup && !_session.setupCompleted) return const Right(unit);
    // Finishing setup creates the business on the server right now, so a
    // rejected field shows up on the form instead of failing in the background.
    final response = await _remote.push(
      saved.getOrElse((_) => throw StateError('saved')).toJson(),
    );
    if (!response.isSuccess) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    return runLocal(_source, () async {
      if (completeSetup) await _session.markSetupCompleted();
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
