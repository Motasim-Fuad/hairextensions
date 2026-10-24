import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/sync/sync_operation.dart';

/// Pushes one queued operation of a single entity type to the server. Each
/// feature provides its own handler through its remote datasource.
abstract interface class SyncHandler {
  String get entity;

  Future<ApiResponse<void>> push(SyncOperation operation);
}
