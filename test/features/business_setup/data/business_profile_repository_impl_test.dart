import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/media/image_permission_denied_exception.dart';
import 'package:hairextensions/core/session/key_value_app_session.dart';
import 'package:hairextensions/core/sync/sqflite_sync_queue.dart';
import 'package:hairextensions/core/sync/sync_operation_type.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source_impl.dart';
import 'package:hairextensions/features/business_setup/data/repositories/business_profile_repository_impl.dart';
import 'package:hairextensions/features/business_setup/data/services/business_profile_reader_impl.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/business_profile_fixture.dart';
import '../../../helpers/fakes/fake_logo_file_store.dart';
import '../../../helpers/fakes/in_memory_key_value_store.dart';
import '../../../helpers/mocks/mock_business_profile_remote_data_source.dart';
import '../../../helpers/mocks/mock_image_source_picker.dart';
import '../../../helpers/test_database.dart';

void main() {
  const profile = BusinessProfileFixture.glamStrands;

  late AppDatabase database;
  late SqfliteSyncQueue queue;
  late BusinessProfileLocalDataSourceImpl local;
  late InMemoryKeyValueStore store;
  late FakeLogoFileStore logos;
  late MockImageSourcePicker picker;
  late MockBusinessProfileRemoteDataSource remote;
  late BusinessProfileRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(<String, Object?>{}));

  setUp(() {
    database = TestDatabase.create();
    queue = SqfliteSyncQueue(database, Clock());
    local = BusinessProfileLocalDataSourceImpl(database);
    store = InMemoryKeyValueStore();
    logos = FakeLogoFileStore();
    picker = MockImageSourcePicker();
    remote = MockBusinessProfileRemoteDataSource();
    when(() => remote.push(any())).thenAnswer((_) async => ApiResponse<void>.success(null));
    repository = BusinessProfileRepositoryImpl(
      local,
      logos,
      picker,
      queue,
      KeyValueAppSession(store),
      Clock(),
      remote,
    );
  });

  tearDown(() async {
    await local.dispose();
    await queue.dispose();
    await database.close();
  });

  Future<void> pick(Future<String?> Function() answer) async {
    when(
      () => picker.pickFromGallery(
        maxDimension: any(named: 'maxDimension'),
        imageQuality: any(named: 'imageQuality'),
      ),
    ).thenAnswer((_) => answer());
  }

  test('returns null before anything is saved', () async {
    expect((await repository.getProfile()).getOrElse((_) => profile), isNull);
  });

  test('saves locally, reads back the same profile and queues one sync row', () async {
    await repository.saveProfile(profile, completeSetup: false);
    await repository.saveProfile(profile, completeSetup: false);

    expect((await repository.getProfile()).getOrElse((_) => null), profile);
    final due = await queue.due(limit: 10);
    expect(due, hasLength(1));
    expect(due.single.entity, BusinessProfileTable.name);
    expect(due.single.type, SyncOperationType.create);
    expect(store.peekBool(StorageKeys.setupCompleted), isNull);
  });

  test('completing setup creates the business on the server and sets the router flag', () async {
    await repository.saveProfile(profile, completeSetup: true);

    verify(() => remote.push(any())).called(1);
    expect(store.peekBool(StorageKeys.setupCompleted), isTrue);
  });

  test('a rejected business keeps setup open and reports the failure', () async {
    when(() => remote.push(any())).thenAnswer(
      (_) async => ApiResponse<void>.failure(statusCode: 422, message: 'The request is not valid.'),
    );

    final result = await repository.saveProfile(profile, completeSetup: true);

    expect(result.isLeft(), isTrue);
    expect(store.peekBool(StorageKeys.setupCompleted), isNull);
    expect((await repository.getProfile()).getOrElse((_) => null), profile);
  });

  test('editing an existing profile does not call the server directly', () async {
    await repository.saveProfile(profile, completeSetup: false);

    verifyNever(() => remote.push(any()));
  });

  test('replacing the logo deletes the previous file', () async {
    final withLogo = BusinessProfileDraft.fromProfile(profile).withLogo('/old.png').toProfile(base: profile);
    final replaced = BusinessProfileDraft.fromProfile(profile).withLogo('/new.png').toProfile(base: profile);

    await repository.saveProfile(withLogo, completeSetup: false);
    await repository.saveProfile(replaced, completeSetup: false);

    expect(logos.deleted, ['/old.png']);
  });

  test('reader emits the saved profile to other features', () async {
    final reader = BusinessProfileReaderImpl(local);
    final emitted = expectLater(reader.watch(), emitsInOrder([null, profile]));

    await pumpEventQueue();
    await repository.saveProfile(profile, completeSetup: false);

    await emitted;
  });

  group('pickLogo', () {
    test('copies the picked image into app storage', () async {
      await pick(() async => 'picked.png');
      expect((await repository.pickLogo()).getOrElse((_) => null), '/stored/picked.png');
    });

    test('cancel is a success with no path', () async {
      await pick(() async => null);
      final result = await repository.pickLogo();
      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => 'x'), isNull);
    });

    test('blocked photo access maps to a permanent permission failure', () async {
      await pick(() async => throw const ImagePermissionDeniedException());
      final failure = (await repository.pickLogo()).getLeft().toNullable();
      expect(failure, isA<PermissionDeniedFailure>());
      expect((failure! as PermissionDeniedFailure).isPermanent, isTrue);
    });
  });
}
