import 'package:hairextensions/core/database/tables/quotes_table.dart';

abstract final class QuoteActivityTable {
  static const String name = 'quote_activity';
  static const String id = 'id';
  static const String quoteId = 'quote_id';
  static const String type = 'type';
  static const String occurredAt = 'occurred_at';
  static const String meta = 'meta';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, '
      '$quoteId TEXT NOT NULL REFERENCES ${QuotesTable.name}(${QuotesTable.id}) ON DELETE CASCADE, '
      '$type TEXT NOT NULL, $occurredAt INTEGER NOT NULL, $meta TEXT)';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_quote ON $name ($quoteId, $occurredAt)',
  ];
}
