import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/migrations/migration_registry.dart';
import 'package:hairextensions/core/database/tables/quote_lines_table.dart';
import 'package:hairextensions/core/database/tables/quotes_table.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = TestDatabase.create());

  tearDown(() => database.close());

  test('creates every table at the latest schema version', () async {
    final db = await database.database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type = 'table'");
    final names = tables.map((row) => row['name']).toSet();

    final version = await db.rawQuery('PRAGMA user_version');

    expect(version.single.values.single, MigrationRegistry.latestVersion);
    expect(
      names,
      containsAll(<String>[
        'key_value',
        'api_cache',
        'sync_queue',
        'business_profile',
        'products',
        'materials',
        'service_templates',
        'quotes',
        'quote_lines',
        'quote_activity',
      ]),
    );
  });

  test('deleting a quote cascades to its lines', () async {
    final db = await database.database;
    final now = DateTime(2026, 10, 14).millisecondsSinceEpoch;
    await db.insert(QuotesTable.name, {
      QuotesTable.id: 'q1',
      QuotesTable.number: 'Q-0001',
      QuotesTable.documentType: 'quote',
      QuotesTable.status: 'draft',
      QuotesTable.clientName: 'Sara',
      QuotesTable.currencyCode: 'AED',
      QuotesTable.depositType: 'percent',
      'created_at': now,
      'updated_at': now,
    });
    await db.insert(QuoteLinesTable.name, {
      QuoteLinesTable.id: 'l1',
      QuoteLinesTable.quoteId: 'q1',
      QuoteLinesTable.category: 'hair',
      QuoteLinesTable.title: 'Tape-in',
      QuoteLinesTable.quantity: 170,
    });

    await db.delete(QuotesTable.name, where: '${QuotesTable.id} = ?', whereArgs: ['q1']);

    expect(await db.query(QuoteLinesTable.name), isEmpty);
  });
}
