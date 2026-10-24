import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/database_migrator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'in_memory_path_resolver.dart';

/// Real migrations on an in-memory sqlite database, isolated per test.
abstract final class TestDatabase {
  static AppDatabase create() {
    sqfliteFfiInit();
    final factory = databaseFactoryFfiNoIsolate;
    return AppDatabase(factory, InMemoryPathResolver(), DatabaseMigrator());
  }
}
