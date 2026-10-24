import 'package:hairextensions/core/database/database_path_resolver.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InMemoryPathResolver implements DatabasePathResolver {
  @override
  Future<String> resolve() async => inMemoryDatabasePath;
}
