import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';

class SyncOperation extends Equatable {
  const SyncOperation({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.type,
    required this.payload,
    required this.attempts,
    required this.createdAt,
    required this.nextAttemptAt,
    this.lastError,
  });

  final int id;
  final String entity;
  final String entityId;
  final SyncOperationType type;
  final Map<String, Object?> payload;
  final int attempts;
  final DateTime createdAt;
  final DateTime nextAttemptAt;
  final String? lastError;

  @override
  List<Object?> get props => [
    id,
    entity,
    entityId,
    type,
    payload,
    attempts,
    createdAt,
    nextAttemptAt,
    lastError,
  ];
}
