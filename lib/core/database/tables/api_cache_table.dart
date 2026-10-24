abstract final class ApiCacheTable {
  static const String name = 'api_cache';
  static const String key = 'key';
  static const String payload = 'payload';
  static const String expiresAt = 'expires_at';
  static const String updatedAt = 'updated_at';
  static const List<String> createStatements = [
    'CREATE TABLE $name ($key TEXT PRIMARY KEY NOT NULL, $payload TEXT NOT NULL, $expiresAt INTEGER NOT NULL, $updatedAt INTEGER NOT NULL)',
    'CREATE INDEX idx_${name}_expires ON $name ($expiresAt)',
  ];
}
