import 'package:hairextensions/core/database/tables/quotes_table.dart';

abstract final class QuoteLinesTable {
  static const String name = 'quote_lines';
  static const String id = 'id';
  static const String quoteId = 'quote_id';
  static const String category = 'category';
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String sourceId = 'source_id';
  static const String quantity = 'quantity';
  static const String unitLabel = 'unit_label';
  static const String unitCostMinor = 'unit_cost_minor';
  static const String unitPriceMinor = 'unit_price_minor';
  static const String costMinor = 'cost_minor';
  static const String priceMinor = 'price_minor';
  static const String hours = 'hours';
  static const String taxable = 'taxable';
  static const String sortOrder = 'sort_order';
  static const String meta = 'meta';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, '
      '$quoteId TEXT NOT NULL REFERENCES ${QuotesTable.name}(${QuotesTable.id}) ON DELETE CASCADE, '
      '$category TEXT NOT NULL, $title TEXT NOT NULL, $subtitle TEXT, $sourceId TEXT, $quantity REAL NOT NULL, '
      '$unitLabel TEXT, $unitCostMinor INTEGER NOT NULL DEFAULT 0, $unitPriceMinor INTEGER NOT NULL DEFAULT 0, '
      '$costMinor INTEGER NOT NULL DEFAULT 0, $priceMinor INTEGER NOT NULL DEFAULT 0, $hours REAL NOT NULL DEFAULT 0, '
      '$taxable INTEGER NOT NULL DEFAULT 1, $sortOrder INTEGER NOT NULL DEFAULT 0, $meta TEXT)';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_quote ON $name ($quoteId, $sortOrder)',
  ];
}
