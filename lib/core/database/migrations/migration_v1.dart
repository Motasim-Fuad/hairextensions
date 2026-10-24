import 'package:hairextensions/core/database/migrations/migration.dart';
import 'package:hairextensions/core/database/tables/api_cache_table.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/database/tables/key_value_table.dart';
import 'package:hairextensions/core/database/tables/materials_table.dart';
import 'package:hairextensions/core/database/tables/products_table.dart';
import 'package:hairextensions/core/database/tables/quote_activity_table.dart';
import 'package:hairextensions/core/database/tables/quote_lines_table.dart';
import 'package:hairextensions/core/database/tables/quotes_table.dart';
import 'package:hairextensions/core/database/tables/service_templates_table.dart';
import 'package:hairextensions/core/database/tables/sync_queue_table.dart';
import 'package:sqflite/sqflite.dart';

class MigrationV1 extends Migration {
  const MigrationV1();

  @override
  int get version => 1;

  @override
  Future<void> migrate(DatabaseExecutor db) async {
    const statements = [
      ...KeyValueTable.createStatements,
      ...ApiCacheTable.createStatements,
      ...SyncQueueTable.createStatements,
      ...BusinessProfileTable.createStatements,
      ...ProductsTable.createStatements,
      ...MaterialsTable.createStatements,
      ...ServiceTemplatesTable.createStatements,
      ...QuotesTable.createStatements,
      ...QuoteLinesTable.createStatements,
      ...QuoteActivityTable.createStatements,
    ];
    for (final statement in statements) {
      await db.execute(statement);
    }
  }
}
