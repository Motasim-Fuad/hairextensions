import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/sync/sync_handler.dart';
import 'package:hairextensions/core/sync/sync_operation.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:injectable/injectable.dart';

/// The profile is a singleton, so create and update are both an idempotent
/// PUT of the latest payload.
@lazySingleton
class BusinessProfileSyncHandler implements SyncHandler {
  BusinessProfileSyncHandler(this._remote);

  final BusinessProfileRemoteDataSource _remote;

  @override
  String get entity => BusinessProfileTable.name;

  @override
  Future<ApiResponse<void>> push(SyncOperation operation) => _remote.push(operation.payload);
}
