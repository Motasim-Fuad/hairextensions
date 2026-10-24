import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/tables/key_value_table.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@LazySingleton(as: KeyValueStore)
class SqfliteKeyValueStore implements KeyValueStore {
  SqfliteKeyValueStore(this._database, this._clock);

  static const String _trueValue = '1';
  static const String _falseValue = '0';

  final AppDatabase _database;
  final Clock _clock;
  final Map<String, String> _memory = {};
  Future<void>? _warming;

  @override
  Future<void> warmUp() => _warming ??= _load();

  Future<void> _load() async {
    final db = await _database.database;
    final rows = await db.query(
      KeyValueTable.name,
      columns: [KeyValueTable.key, KeyValueTable.value],
    );
    for (final row in rows) {
      final value = row[KeyValueTable.value];
      if (value is String) {
        _memory[row[KeyValueTable.key]! as String] = value;
      }
    }
  }

  @override
  String? peekString(String key) => _memory[key];

  @override
  bool? peekBool(String key) => _decodeBool(_memory[key]);

  @override
  Future<String?> getString(String key) async {
    await warmUp();
    return _memory[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    await warmUp();
    _memory[key] = value;
    final db = await _database.database;
    await db.insert(
      KeyValueTable.name,
      {
        KeyValueTable.key: key,
        KeyValueTable.value: value,
        KeyValueTable.updatedAt: _clock.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool?> getBool(String key) async => _decodeBool(await getString(key));

  @override
  Future<void> setBool(String key, {required bool value}) => setString(key, value ? _trueValue : _falseValue);

  @override
  Future<int?> getInt(String key) async {
    final raw = await getString(key);
    return raw == null ? null : int.tryParse(raw);
  }

  @override
  Future<void> setInt(String key, int value) => setString(key, value.toString());

  @override
  Future<void> remove(String key) async {
    _memory.remove(key);
    final db = await _database.database;
    await db.delete(
      KeyValueTable.name,
      where: '${KeyValueTable.key} = ?',
      whereArgs: [key],
    );
  }

  @override
  Future<void> clear() async {
    _memory.clear();
    final db = await _database.database;
    await db.delete(KeyValueTable.name);
  }

  bool? _decodeBool(String? raw) {
    if (raw == null) {
      return null;
    }
    return raw == _trueValue;
  }
}
