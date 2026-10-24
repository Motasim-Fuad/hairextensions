import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/sync/sync_operation.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_mock.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';
import 'package:hairextensions/features/business_setup/data/sync/business_profile_sync_handler.dart';

import '../../../fixtures/business_profile_fixture.dart';

void main() {
  test('pushes the queued payload to the mock server, which then serves it', () async {
    final remote = BusinessProfileRemoteDataSourceMock();
    final handler = BusinessProfileSyncHandler(remote);
    final payload = BusinessProfileMapper.toModel(
      BusinessProfileFixture.glamStrands,
      createdAt: 1,
      updatedAt: 2,
    ).toJson();

    final pushed = await handler.push(
      SyncOperation(
        id: 1,
        entity: BusinessProfileTable.name,
        entityId: '1',
        type: SyncOperationType.create,
        payload: payload,
        attempts: 0,
        createdAt: DateTime(2026),
        nextAttemptAt: DateTime(2026),
      ),
    );
    final fetched = await remote.fetch();

    expect(handler.entity, BusinessProfileTable.name);
    expect(pushed.isSuccess, isTrue);
    expect(fetched.data?.businessName, BusinessProfileFixture.glamStrands.businessName);
  });
}
