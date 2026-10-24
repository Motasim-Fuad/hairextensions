import 'dart:async';
import 'dart:convert';

import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/tables/sync_queue_table.dart';
import 'package:hairextensions/core/sync/sync_operation.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/core/sync/sync_queue.dart';
import 'package:hairextensions/core/sync/sync_queue_status.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@LazySingleton(as: SyncQueue)
class SqfliteSyncQueue implements SyncQueue {
  SqfliteSyncQueue(this._database, this._clock);

  final AppDatabase _database;
  final Clock _clock;
  final StreamController<void> _enqueued = StreamController<void>.broadcast();

  @override
  Stream<void> get onEnqueued => _enqueued.stream;

  @override
  Future<void> enqueue({
    required String entity,
    required String entityId,
    required SyncOperationType type,
    Map<String, Object?> payload = const {},
  }) async {
    final db = await _database.database;
    await db.transaction((txn) async {
      final existing = await txn.query(
        SyncQueueTable.name,
        where: '${SyncQueueTable.entity} = ? AND ${SyncQueueTable.entityId} = ? AND ${SyncQueueTable.status} = ?',
        whereArgs: [entity, entityId, SyncQueueStatus.pending.name],
        limit: 1,
      );
      if (existing.isEmpty) {
        await txn.insert(
          SyncQueueTable.name,
          _newRow(entity, entityId, type, payload),
        );
        return;
      }
      final row = existing.first;
      final id = row[SyncQueueTable.id]! as int;
      final previous = SyncOperationType.fromName(
        row[SyncQueueTable.operation]! as String,
      );
      final merged = _merge(previous, type);
      if (merged == null) {
        await txn.delete(
          SyncQueueTable.name,
          where: '${SyncQueueTable.id} = ?',
          whereArgs: [id],
        );
        return;
      }
      await txn.update(
        SyncQueueTable.name,
        {
          SyncQueueTable.operation: merged.name,
          SyncQueueTable.payload: jsonEncode(payload),
          SyncQueueTable.attempts: 0,
          SyncQueueTable.nextAttemptAt: _clock.now().millisecondsSinceEpoch,
        },
        where: '${SyncQueueTable.id} = ?',
        whereArgs: [id],
      );
    });
    _enqueued.add(null);
  }

  /// Null means the two operations cancel out (created and deleted offline).
  SyncOperationType? _merge(
    SyncOperationType previous,
    SyncOperationType next,
  ) {
    if (previous == SyncOperationType.create && next == SyncOperationType.delete) {
      return null;
    }
    if (previous == SyncOperationType.create) {
      return SyncOperationType.create;
    }
    if (previous == SyncOperationType.delete && next == SyncOperationType.create) {
      return SyncOperationType.update;
    }
    return next;
  }

  Map<String, Object?> _newRow(
    String entity,
    String entityId,
    SyncOperationType type,
    Map<String, Object?> payload,
  ) {
    final now = _clock.now().millisecondsSinceEpoch;
    return {
      SyncQueueTable.entity: entity,
      SyncQueueTable.entityId: entityId,
      SyncQueueTable.operation: type.name,
      SyncQueueTable.payload: jsonEncode(payload),
      SyncQueueTable.status: SyncQueueStatus.pending.name,
      SyncQueueTable.attempts: 0,
      SyncQueueTable.createdAt: now,
      SyncQueueTable.nextAttemptAt: now,
    };
  }

  @override
  Future<List<SyncOperation>> due({required int limit}) async {
    final db = await _database.database;
    final rows = await db.query(
      SyncQueueTable.name,
      where: '${SyncQueueTable.status} = ? AND ${SyncQueueTable.nextAttemptAt} <= ?',
      whereArgs: [
        SyncQueueStatus.pending.name,
        _clock.now().millisecondsSinceEpoch,
      ],
      orderBy: '${SyncQueueTable.id} ASC',
      limit: limit,
    );
    return rows.map(_toOperation).toList();
  }

  @override
  Future<DateTime?> nextDueAt() async {
    final db = await _database.database;
    final rows = await db.query(
      SyncQueueTable.name,
      columns: [SyncQueueTable.nextAttemptAt],
      where: '${SyncQueueTable.status} = ?',
      whereArgs: [SyncQueueStatus.pending.name],
      orderBy: '${SyncQueueTable.nextAttemptAt} ASC',
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(
      rows.first[SyncQueueTable.nextAttemptAt]! as int,
    );
  }

  @override
  Future<void> markInFlight(int id) => _setStatus(id, SyncQueueStatus.inFlight);

  @override
  Future<void> complete(int id) async {
    final db = await _database.database;
    await db.delete(
      SyncQueueTable.name,
      where: '${SyncQueueTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> reschedule(
    int id, {
    required int attempts,
    required DateTime nextAttemptAt,
    required String error,
  }) async {
    final db = await _database.database;
    await db.update(
      SyncQueueTable.name,
      {
        SyncQueueTable.status: SyncQueueStatus.pending.name,
        SyncQueueTable.attempts: attempts,
        SyncQueueTable.nextAttemptAt: nextAttemptAt.millisecondsSinceEpoch,
        SyncQueueTable.lastError: error,
      },
      where: '${SyncQueueTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> abandon(int id, String error) async {
    final db = await _database.database;
    await db.update(
      SyncQueueTable.name,
      {
        SyncQueueTable.status: SyncQueueStatus.dead.name,
        SyncQueueTable.lastError: error,
      },
      where: '${SyncQueueTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> recoverInFlight() async {
    final db = await _database.database;
    await db.update(
      SyncQueueTable.name,
      {SyncQueueTable.status: SyncQueueStatus.pending.name},
      where: '${SyncQueueTable.status} = ?',
      whereArgs: [SyncQueueStatus.inFlight.name],
    );
  }

  @override
  Future<int> pendingCount() async {
    final db = await _database.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${SyncQueueTable.name} WHERE ${SyncQueueTable.status} != ?',
      [SyncQueueStatus.dead.name],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> _setStatus(int id, SyncQueueStatus status) async {
    final db = await _database.database;
    await db.update(
      SyncQueueTable.name,
      {SyncQueueTable.status: status.name},
      where: '${SyncQueueTable.id} = ?',
      whereArgs: [id],
    );
  }

  SyncOperation _toOperation(Map<String, Object?> row) {
    return SyncOperation(
      id: row[SyncQueueTable.id]! as int,
      entity: row[SyncQueueTable.entity]! as String,
      entityId: row[SyncQueueTable.entityId]! as String,
      type: SyncOperationType.fromName(
        row[SyncQueueTable.operation]! as String,
      ),
      payload: Map<String, Object?>.from(
        jsonDecode(row[SyncQueueTable.payload]! as String) as Map,
      ),
      attempts: row[SyncQueueTable.attempts]! as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row[SyncQueueTable.createdAt]! as int,
      ),
      nextAttemptAt: DateTime.fromMillisecondsSinceEpoch(
        row[SyncQueueTable.nextAttemptAt]! as int,
      ),
      lastError: row[SyncQueueTable.lastError] as String?,
    );
  }

  @override
  @disposeMethod
  Future<void> dispose() => _enqueued.close();
}
