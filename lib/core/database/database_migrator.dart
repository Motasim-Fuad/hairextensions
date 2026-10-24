import 'package:hairextensions/core/database/migrations/migration.dart';
import 'package:hairextensions/core/database/migrations/migration_registry.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

/// Applies every pending migration inside one transaction so a failed step
/// leaves the previous schema untouched instead of a half-migrated database.
@lazySingleton
class DatabaseMigrator {
  DatabaseMigrator({@ignoreParam List<Migration>? migrations}) : _migrations = migrations ?? MigrationRegistry.all;

  static const String _source = 'DatabaseMigrator';

  final List<Migration> _migrations;

  int get latestVersion => _migrations.last.version;

  Future<void> onCreate(Database db, int version) => _migrate(db, 0, version);

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) => _migrate(db, oldVersion, newVersion);

  /// A newer schema left by a rolled-back build stays readable because
  /// migrations only add columns and tables, so data is kept.
  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.warning(
      _source,
      'downgrade from $oldVersion to $newVersion kept existing schema',
    );
  }

  Future<void> _migrate(Database db, int fromVersion, int toVersion) async {
    final pending =
        _migrations
            .where(
              (migration) => migration.version > fromVersion && migration.version <= toVersion,
            )
            .toList()
          ..sort((a, b) => a.version.compareTo(b.version));
    await db.transaction((txn) async {
      for (final migration in pending) {
        AppLogger.debug(_source, 'applying version ${migration.version}');
        await migration.migrate(txn);
      }
    });
  }
}
