import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/sync/sqflite_sync_queue.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/core/utils/clock.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late SqfliteSyncQueue queue;

  setUp(() {
    database = TestDatabase.create();
    queue = SqfliteSyncQueue(database, Clock());
  });

  tearDown(() async {
    await queue.dispose();
    await database.close();
  });

  test('create then update keeps a single create with the latest payload', () async {
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.create, payload: {'v': 1});
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.update, payload: {'v': 2});

    final due = await queue.due(limit: 10);

    expect(due, hasLength(1));
    expect(due.single.type, SyncOperationType.create);
    expect(due.single.payload, {'v': 2});
  });

  test('create then delete cancels out', () async {
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.create);
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.delete);

    expect(await queue.pendingCount(), 0);
  });

  test('in-flight operations are not merged and are recovered as pending', () async {
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.update, payload: {'v': 1});
    final first = (await queue.due(limit: 10)).single;
    await queue.markInFlight(first.id);
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.update, payload: {'v': 2});

    await queue.recoverInFlight();

    expect(await queue.due(limit: 10), hasLength(2));
  });

  test('rescheduled operations are not due until their next attempt', () async {
    await queue.enqueue(entity: 'quote', entityId: 'q1', type: SyncOperationType.update);
    final operation = (await queue.due(limit: 10)).single;

    await queue.reschedule(
      operation.id,
      attempts: 1,
      nextAttemptAt: DateTime.now().add(const Duration(hours: 1)),
      error: 'timeout',
    );

    expect(await queue.due(limit: 10), isEmpty);
    expect(await queue.nextDueAt(), isNotNull);
  });
}
