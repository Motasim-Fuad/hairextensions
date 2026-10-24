import 'package:hairextensions/core/constants/database_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabasePathResolver {
  DatabasePathResolver(this._factory);

  final DatabaseFactory _factory;

  Future<String> resolve() async {
    final directory = await _factory.getDatabasesPath();
    return join(directory, DatabaseConstants.fileName);
  }
}
