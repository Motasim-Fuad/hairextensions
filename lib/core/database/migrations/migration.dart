import 'package:sqflite/sqflite.dart';

/// One schema step. [version] is the schema version after this step runs.
/// Steps are append-only: never edit a released migration, add a new one.
abstract class Migration {
  const Migration();

  int get version;

  Future<void> migrate(DatabaseExecutor db);
}
