import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/contracts/account_restorer.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/core/sync/sync_queue.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:injectable/injectable.dart';

/// After login: copy the account's business from the server so a returning
/// stylist skips setup, also on a new phone. Before the next login: forget the
/// previous account's local data.
@LazySingleton(as: AccountRestorer)
class BusinessAccountRestorer implements AccountRestorer {
  BusinessAccountRestorer(this._remote, this._local, this._session, this._queue);

  final BusinessProfileRemoteDataSource _remote;
  final BusinessProfileLocalDataSource _local;
  final AppSession _session;
  final SyncQueue _queue;

  @override
  Future<Either<Failure, bool>> restore() async {
    final response = await _remote.fetch();
    if (!response.isSuccess) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    final model = response.data;
    if (model == null) {
      return const Right(false);
    }
    await _local.upsert(model);
    await _session.markSetupCompleted();
    return const Right(true);
  }

  @override
  Future<void> syncMissingBusiness() async {
    final response = await _remote.fetch();
    if (!response.isSuccess || response.data != null) {
      return;
    }
    final local = await _local.read();
    if (local == null) {
      return;
    }
    await _queue.enqueue(
      entity: BusinessProfileTable.name,
      entityId: '${BusinessProfileTable.singletonId}',
      type: SyncOperationType.create,
      payload: local.toJson(),
    );
  }

  @override
  Future<void> clearLocal() async {
    await _queue.clearAll();
    await _local.clear();
  }
}
