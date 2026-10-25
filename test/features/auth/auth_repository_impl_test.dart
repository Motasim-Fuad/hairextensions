import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/session/session_refresh.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/models/register_pending_model.dart';
import 'package:hairextensions/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes/fake_app_session.dart';
import '../../helpers/mocks/mock_account_restorer.dart';
import '../../helpers/mocks/mock_auth_remote_data_source.dart';
import '../../helpers/mocks/mock_secure_token_store.dart';

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSecureTokenStore tokens;
  late MockAccountRestorer restorer;
  late FakeAppSession session;
  late SessionRefresh refresh;
  late AuthRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(const AuthTokens(accessToken: 'a')));

  setUp(() {
    remote = MockAuthRemoteDataSource();
    tokens = MockSecureTokenStore();
    restorer = MockAccountRestorer();
    session = FakeAppSession();
    refresh = SessionRefresh();
    when(() => tokens.save(any())).thenAnswer((_) async {});
    when(() => tokens.clear()).thenAnswer((_) async {});
    when(() => restorer.clearLocal()).thenAnswer((_) async {});
    when(() => restorer.restore()).thenAnswer((_) async => const Right<Failure, bool>(true));
    repository = AuthRepositoryImpl(remote, tokens, session, restorer, refresh);
  });

  void stubLogin(ApiResponse<AuthTokensModel> response) {
    when(
      () => remote.login(email: any(named: 'email'), password: any(named: 'password')),
    ).thenAnswer((_) async => response);
  }

  group('login', () {
    test('stores the token, restores the business and marks the session signed in', () async {
      stubLogin(ApiResponse.success(const AuthTokensModel(accessToken: 'token')));

      final result = await repository.login(email: 'amna@example.com', password: 'secret123');

      expect(result.isRight(), isTrue);
      verify(() => tokens.save(const AuthTokens(accessToken: 'token'))).called(1);
      verify(() => restorer.restore()).called(1);
      expect(session.signedIn, isTrue);
    });

    test('wrong credentials store nothing and leave the session signed out', () async {
      stubLogin(ApiResponse.failure(statusCode: 401, message: 'Invalid credentials'));

      final result = await repository.login(email: 'amna@example.com', password: 'nope');

      expect(result.isLeft(), isTrue);
      verifyNever(() => tokens.save(any()));
      verifyNever(() => restorer.restore());
      expect(session.signedIn, isFalse);
    });

    test('an offline restore rolls the sign-in back so it can be retried', () async {
      stubLogin(ApiResponse.success(const AuthTokensModel(accessToken: 'token')));
      when(() => restorer.restore()).thenAnswer((_) async => const Left<Failure, bool>(LocalStorageFailure()));

      final result = await repository.login(email: 'amna@example.com', password: 'secret123');

      expect(result.isLeft(), isTrue);
      verify(() => tokens.clear()).called(1);
      expect(session.signedIn, isFalse);
    });
  });

  group('registration', () {
    test('keeps the code a local backend returns, once', () async {
      when(
        () => remote.register(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer(
        (_) async => ApiResponse.success(
          const RegisterPendingModel(email: 'amna@example.com', message: 'sent', otp: '123456'),
          statusCode: 201,
        ),
      );

      final result = await repository.register(name: 'Amna', email: 'Amna@Example.com', password: 'secret123');

      expect(result.isRight(), isTrue);
      expect(repository.takePendingOtp('amna@example.com'), '123456');
      expect(repository.takePendingOtp('amna@example.com'), isNull);
    });

    test('a failed registration reports the failure', () async {
      when(
        () => remote.register(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => ApiResponse.failure(errorType: ApiErrorType.network));

      final result = await repository.register(name: 'Amna', email: 'amna@example.com', password: 'secret123');

      expect(result.isLeft(), isTrue);
    });

    test('verifying the code maps a rejected code to a failure', () async {
      when(
        () => remote.verifyOtp(email: any(named: 'email'), otp: any(named: 'otp')),
      ).thenAnswer((_) async => ApiResponse<void>.failure(statusCode: 400, message: 'Invalid code'));

      final result = await repository.verifyOtp(email: 'amna@example.com', otp: '000000');

      expect(result.isLeft(), isTrue);
    });
  });

  test('ending the session clears the token and local data and notifies the router', () async {
    session
      ..signedIn = true
      ..setupCompleted = true;
    var notified = 0;
    refresh.addListener(() => notified++);

    await repository.endSession();

    verify(() => tokens.clear()).called(1);
    verify(() => restorer.clearLocal()).called(1);
    expect(session.signedIn, isFalse);
    expect(session.setupCompleted, isFalse);
    expect(notified, 1);
  });
}
