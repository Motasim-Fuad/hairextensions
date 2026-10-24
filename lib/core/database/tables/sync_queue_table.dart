abstract final class SyncQueueTable {
  static const String name = 'sync_queue';
  static const String id = 'id';
  static const String entity = 'entity';
  static const String entityId = 'entity_id';
  static const String operation = 'operation';
  static const String payload = 'payload';
  static const String status = 'status';
  static const String attempts = 'attempts';
  static const String lastError = 'last_error';
  static const String createdAt = 'created_at';
  static const String nextAttemptAt = 'next_attempt_at';
  static const String createTable =
      'CREATE TABLE $name ($id INTEGER PRIMARY KEY AUTOINCREMENT, $entity TEXT NOT NULL, $entityId TEXT NOT NULL, '
      '$operation TEXT NOT NULL, $payload TEXT NOT NULL, $status TEXT NOT NULL, $attempts INTEGER NOT NULL DEFAULT 0, '
      '$lastError TEXT, $createdAt INTEGER NOT NULL, $nextAttemptAt INTEGER NOT NULL)';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_due ON $name ($status, $nextAttemptAt)',
    'CREATE INDEX idx_${name}_entity ON $name ($entity, $entityId)',
  ];
}
