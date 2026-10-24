import 'package:hairextensions/core/constants/database_constants.dart';
import 'package:hairextensions/core/database/database_migrator.dart';
import 'package:hairextensions/core/database/database_path_resolver.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

/// Opens the database lazily on first use. Concurrent callers share one open.
@lazySingleton
class AppDatabase {
  AppDatabase(this._factory, this._pathResolver, this._migrator);

  static const String _source = 'AppDatabase';

  final DatabaseFactory _factory;
  final DatabasePathResolver _pathResolver;
  final DatabaseMigrator _migrator;
  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();

  Future<Database> _open() async {
    try {
      final path = await _pathResolver.resolve();
      final db = await _factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: _migrator.latestVersion,
          onConfigure: _configure,
          onCreate: _migrator.onCreate,
          onUpgrade: _migrator.onUpgrade,
          onDowngrade: _migrator.onDowngrade,
        ),
      );
      AppLogger.debug(_source, 'opened version ${_migrator.latestVersion}');
      return db;
    } on Object catch (error) {
      _opening = null;
      AppLogger.error(_source, 'open failed', error);
      rethrow;
    }
  }

  Future<void> _configure(Database db) async {
    await db.execute(DatabaseConstants.enableForeignKeys);
    await db.rawQuery(DatabaseConstants.enableWriteAheadLog);
  }

  /// Wipes every table for the "Delete all my data" action.
  Future<void> deleteAllData() async {
    await close();
    await _factory.deleteDatabase(await _pathResolver.resolve());
  }

  @disposeMethod
  Future<void> close() async {
    final opening = _opening;
    _opening = null;
    if (opening != null) {
      await (await opening).close();
    }
  }
}
