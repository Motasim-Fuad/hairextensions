import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/identity/device_id_provider.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/fakes/in_memory_key_value_store.dart';
import '../../helpers/mocks/mock_auth_remote_data_source.dart';
import '../../helpers/mocks/mock_secure_token_store.dart';

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSecureTokenStore tokens;
  late AuthRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(const AuthTokens(accessToken: 'a', refreshToken: 'r')));

  setUp(() {
    remote = MockAuthRemoteDataSource();
    tokens = MockSecureTokenStore();
    when(() => tokens.save(any())).thenAnswer((_) async {});
    repository = AuthRepositoryImpl(
      remote,
      tokens,
      DeviceIdProvider(InMemoryKeyValueStore(), IdGenerator(const Uuid())),
      Clock(),
    );
  });

  void stubRegister(ApiResponse<AuthTokensModel> response) {
    when(
      () => remote.registerDevice(
        deviceId: any(named: 'deviceId'),
        platform: any(named: 'platform'),
      ),
    ).thenAnswer((_) async => response);
  }

  test('reuses stored tokens without calling the server', () async {
    when(() => tokens.read()).thenAnswer((_) async => const AuthTokens(accessToken: 'a', refreshToken: 'r'));

    final result = await repository.ensureSession();

    expect(result.isRight(), isTrue);
    verifyNever(
      () => remote.registerDevice(
        deviceId: any(named: 'deviceId'),
        platform: any(named: 'platform'),
      ),
    );
  });

  test('registers the device once and stores the tokens', () async {
    when(() => tokens.read()).thenAnswer((_) async => null);
    stubRegister(
      ApiResponse.success(const AuthTokensModel(accessToken: 'a', refreshToken: 'r', expiresInSeconds: 60)),
    );

    final results = await Future.wait([repository.ensureSession(), repository.ensureSession()]);

    expect(results.every((result) => result.isRight()), isTrue);
    verify(
      () => remote.registerDevice(
        deviceId: any(named: 'deviceId'),
        platform: any(named: 'platform'),
      ),
    ).called(1);
    verify(() => tokens.save(any())).called(1);
  });

  test('offline registration fails without storing anything', () async {
    when(() => tokens.read()).thenAnswer((_) async => null);
    stubRegister(ApiResponse.failure(errorType: ApiErrorType.network));

    final result = await repository.ensureSession();

    expect(result.isLeft(), isTrue);
    verifyNever(() => tokens.save(any()));
  });
}
