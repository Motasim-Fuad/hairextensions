import 'package:hairextensions/core/sync/sync_operation.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';

/// Durable queue of local writes waiting to reach the server.
abstract interface class SyncQueue {
  Stream<void> get onEnqueued;

  /// Coalesces with a pending operation for the same entity id so the server
  /// only receives the final state.
  Future<void> enqueue({
    required String entity,
    required String entityId,
    required SyncOperationType type,
    Map<String, Object?> payload = const {},
  });

  Future<List<SyncOperation>> due({required int limit});

  Future<DateTime?> nextDueAt();

  Future<void> markInFlight(int id);

  Future<void> complete(int id);

  Future<void> reschedule(
    int id, {
    required int attempts,
    required DateTime nextAttemptAt,
    required String error,
  });

  Future<void> abandon(int id, String error);

  /// Returns rows left in flight by a killed process to pending.
  Future<void> recoverInFlight();

  Future<int> pendingCount();

  /// Drops every queued operation, used when the account signs out so one
  /// stylist's pending writes never reach another account.
  Future<void> clearAll();

  Future<void> dispose();
}
