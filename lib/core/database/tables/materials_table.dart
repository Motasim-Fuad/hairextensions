import 'package:hairextensions/core/database/tables/sync_columns.dart';

abstract final class MaterialsTable {
  static const String name = 'materials';
  static const String id = 'id';
  static const String materialName = 'name';
  static const String unitLabel = 'unit_label';
  static const String unitCostMinor = 'unit_cost_minor';
  static const String pricingMode = 'pricing_mode';
  static const String markupPercent = 'markup_percent';
  static const String retailPerUnitMinor = 'retail_per_unit_minor';
  static const String taxable = 'taxable';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, $materialName TEXT NOT NULL, $unitLabel TEXT NOT NULL, '
      '$unitCostMinor INTEGER NOT NULL, $pricingMode TEXT NOT NULL, $markupPercent REAL NOT NULL DEFAULT 0, '
      '$retailPerUnitMinor INTEGER NOT NULL DEFAULT 0, $taxable INTEGER NOT NULL DEFAULT 1, ${SyncColumns.definition})';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_updated ON $name (${SyncColumns.updatedAt})',
  ];
}
