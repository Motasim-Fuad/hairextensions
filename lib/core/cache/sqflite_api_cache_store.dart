import 'package:hairextensions/core/cache/api_cache_store.dart';
import 'package:hairextensions/core/cache/cached_payload.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/tables/api_cache_table.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@LazySingleton(as: ApiCacheStore)
class SqfliteApiCacheStore implements ApiCacheStore {
  SqfliteApiCacheStore(this._database, this._clock);

  final AppDatabase _database;
  final Clock _clock;

  @override
  Future<CachedPayload?> read(String key) async {
    final db = await _database.database;
    final rows = await db.query(
      ApiCacheTable.name,
      columns: [ApiCacheTable.payload, ApiCacheTable.expiresAt],
      where: '${ApiCacheTable.key} = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first;
    final expiresAt = row[ApiCacheTable.expiresAt]! as int;
    return CachedPayload(
      payload: row[ApiCacheTable.payload]! as String,
      isExpired: expiresAt <= _clock.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> write(String key, String payload, Duration ttl) async {
    final db = await _database.database;
    final now = _clock.now();
    await db.insert(
      ApiCacheTable.name,
      {
        ApiCacheTable.key: key,
        ApiCacheTable.payload: payload,
        ApiCacheTable.expiresAt: now.add(ttl).millisecondsSinceEpoch,
        ApiCacheTable.updatedAt: now.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> invalidate(String key) async {
    final db = await _database.database;
    await db.delete(
      ApiCacheTable.name,
      where: '${ApiCacheTable.key} = ?',
      whereArgs: [key],
    );
  }

  @override
  Future<void> purgeExpired() async {
    final db = await _database.database;
    await db.delete(
      ApiCacheTable.name,
      where: '${ApiCacheTable.expiresAt} <= ?',
      whereArgs: [_clock.now().millisecondsSinceEpoch],
    );
  }
}
