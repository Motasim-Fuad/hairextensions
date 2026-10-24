import 'dart:async';

import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/database/tables/sync_columns.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@LazySingleton(as: BusinessProfileLocalDataSource)
class BusinessProfileLocalDataSourceImpl implements BusinessProfileLocalDataSource {
  BusinessProfileLocalDataSourceImpl(this._database);

  static const String _pendingStatus = 'pending';

  final AppDatabase _database;
  final StreamController<BusinessProfileModel> _changes = StreamController<BusinessProfileModel>.broadcast();

  @override
  Stream<BusinessProfileModel> get changes => _changes.stream;

  @override
  Future<BusinessProfileModel?> read() async {
    final db = await _database.database;
    final rows = await db.query(
      BusinessProfileTable.name,
      where: '${BusinessProfileTable.id} = ? AND ${SyncColumns.deletedAt} IS NULL',
      whereArgs: [BusinessProfileTable.singletonId],
      limit: 1,
    );
    return rows.isEmpty ? null : BusinessProfileModel.fromRow(rows.first);
  }

  @override
  Future<void> upsert(BusinessProfileModel model) async {
    final db = await _database.database;
    await db.insert(
      BusinessProfileTable.name,
      model.toRow(syncStatus: _pendingStatus),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _changes.add(model);
  }

  @override
  @disposeMethod
  Future<void> dispose() => _changes.close();
}
