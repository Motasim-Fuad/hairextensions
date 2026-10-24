abstract final class KeyValueTable {
  static const String name = 'key_value';
  static const String key = 'key';
  static const String value = 'value';
  static const String updatedAt = 'updated_at';
  static const List<String> createStatements = [
    'CREATE TABLE $name ($key TEXT PRIMARY KEY NOT NULL, $value TEXT, $updatedAt INTEGER NOT NULL)',
  ];
}
