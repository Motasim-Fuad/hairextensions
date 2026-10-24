import 'package:hairextensions/core/database/tables/sync_columns.dart';

/// Labor services and add-on services share this table, split by [kind].
abstract final class ServiceTemplatesTable {
  static const String name = 'service_templates';
  static const String id = 'id';
  static const String templateName = 'name';
  static const String kind = 'kind';
  static const String rateType = 'rate_type';
  static const String rateMinor = 'rate_minor';
  static const String defaultHours = 'default_hours';
  static const String taxable = 'taxable';
  static const String countsTowardHours = 'counts_toward_hours';
  static const String sortOrder = 'sort_order';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, $templateName TEXT NOT NULL, $kind TEXT NOT NULL, '
      '$rateType TEXT NOT NULL, $rateMinor INTEGER NOT NULL, $defaultHours REAL NOT NULL DEFAULT 0, '
      '$taxable INTEGER NOT NULL DEFAULT 1, $countsTowardHours INTEGER NOT NULL DEFAULT 1, '
      '$sortOrder INTEGER NOT NULL DEFAULT 0, ${SyncColumns.definition})';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_kind ON $name ($kind, $sortOrder)',
  ];
}
