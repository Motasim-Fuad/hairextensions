import 'package:hairextensions/core/database/tables/sync_columns.dart';

abstract final class ProductsTable {
  static const String name = 'products';
  static const String id = 'id';
  static const String productName = 'name';
  static const String type = 'type';
  static const String length = 'length';
  static const String lengthUnit = 'length_unit';
  static const String colour = 'colour';
  static const String soldBy = 'sold_by';
  static const String packPriceMinor = 'pack_price_minor';
  static const String unitsPerPack = 'units_per_pack';
  static const String pricingMode = 'pricing_mode';
  static const String markupPercent = 'markup_percent';
  static const String retailPerUnitMinor = 'retail_per_unit_minor';
  static const String taxable = 'taxable';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, $productName TEXT NOT NULL, $type TEXT NOT NULL, '
      '$length REAL, $lengthUnit TEXT, $colour TEXT, $soldBy TEXT NOT NULL, $packPriceMinor INTEGER NOT NULL, '
      '$unitsPerPack REAL NOT NULL, $pricingMode TEXT NOT NULL, $markupPercent REAL NOT NULL DEFAULT 0, '
      '$retailPerUnitMinor INTEGER NOT NULL DEFAULT 0, $taxable INTEGER NOT NULL DEFAULT 1, ${SyncColumns.definition})';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_updated ON $name (${SyncColumns.updatedAt})',
  ];
}
