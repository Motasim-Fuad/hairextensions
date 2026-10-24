import 'package:hairextensions/core/database/migrations/migration.dart';
import 'package:hairextensions/core/database/migrations/migration_v1.dart';

/// Ordered list of schema steps. To change the schema add MigrationV2 here;
/// the database version follows automatically.
abstract final class MigrationRegistry {
  static const List<Migration> all = [
    MigrationV1(),
  ];

  static int get latestVersion => all.last.version;
}
