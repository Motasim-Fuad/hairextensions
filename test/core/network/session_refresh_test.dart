import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/network/interceptors/auth_interceptor.dart';
import 'package:hairextensions/core/network/interceptors/session_expiry_interceptor.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';

class Store implements SecureTokenStore {
  AuthTokens? tokens = const AuthTokens(
    accessToken: 'old',
    refreshToken: 'refresh-old',
  );
  @override
  String? get cachedAccessToken => tokens?.accessToken;
  @override
  Future<AuthTokens?> read() async => tokens;
  @override
  Future<void> save(AuthTokens value) async {
    tokens = value;
  }

  @override
  Future<void> clear() async {
    tokens = null;
  }
}

class Adapter implements HttpClientAdapter {
  Adapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions) respond;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) => respond(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(int code, Object data) => ResponseBody.fromString(
  jsonEncode(data),
  code,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);
void main() {
  late Store store;
  late Dio dio;
  late SessionExpiryNotifier expiry;
  setUp(() {
    store = Store();
    expiry = SessionExpiryNotifier();
    dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
    dio.interceptors.addAll([
      AuthInterceptor(store),
      SessionExpiryInterceptor(
        dio: dio,
        tokenStore: store,
        expiryNotifier: expiry,
      ),
    ]);
  });
  tearDown(() async {
    await expiry.dispose();
  });
  test(
    'concurrent 401s rotate once and replay all original requests',
    () async {
      var refreshes = 0;
      var expired = 0;
      final subscription = expiry.onExpired.listen((_) => expired++);
      dio.httpClientAdapter = Adapter((request) async {
        if (request.path.endsWith('/refresh')) {
          refreshes++;
          expect(request.data, {'refresh_token': 'refresh-old'});
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return jsonBody(200, {
            'access_token': 'new',
            'refresh_token': 'refresh-new',
            'expires_at': '2030-01-01T00:00:00Z',
          });
        }
        return jsonBody(
          request.headers['Authorization'] == 'Bearer new' ? 200 : 401,
          {'ok': true},
        );
      });
      final responses = await Future.wait(
        List.generate(8, (i) => dio.get<Object?>('/resource/$i')),
      );
      expect(responses.every((r) => r.statusCode == 200), isTrue);
      expect(refreshes, 1);
      expect(store.tokens?.refreshToken, 'refresh-new');
      expect(expired, 0);
      await subscription.cancel();
    },
  );
  test(
    'refresh transport failure preserves tokens and does not logout',
    () async {
      var expired = 0;
      final sub = expiry.onExpired.listen((_) => expired++);
      dio.httpClientAdapter = Adapter((request) async {
        if (request.path.endsWith('/refresh'))
          throw DioException(
            requestOptions: request,
            type: DioExceptionType.connectionError,
          );
        return jsonBody(401, {});
      });
      await expectLater(
        dio.get<Object?>('/resource'),
        throwsA(isA<DioException>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(store.tokens?.accessToken, 'old');
      expect(expired, 0);
      await sub.cancel();
    },
  );
  test('invalid refresh ends the session once', () async {
    var expired = 0;
    final sub = expiry.onExpired.listen((_) => expired++);
    dio.httpClientAdapter = Adapter((request) async => jsonBody(401, {}));
    await expectLater(
      dio.get<Object?>('/resource'),
      throwsA(isA<DioException>()),
    );
    await Future<void>.delayed(Duration.zero);
    expect(store.tokens, isNull);
    expect(expired, 1);
    await sub.cancel();
  });
  test('late refresh cannot restore a logged out account', () async {
    final entered = Completer<void>();
    final release = Completer<void>();
    dio.httpClientAdapter = Adapter((request) async {
      if (request.path.endsWith('/refresh')) {
        entered.complete();
        await release.future;
        return jsonBody(200, {
          'access_token': 'new',
          'refresh_token': 'refresh-new',
        });
      }
      return jsonBody(401, {});
    });
    final request = dio.get<Object?>('/resource');
    final expectation = expectLater(request, throwsA(isA<DioException>()));
    await entered.future;
    await store.clear();
    release.complete();
    await expectation;
    expect(store.tokens, isNull);
  });
  test('a rejected renewed access token never loops refresh', () async {
    var refreshes = 0;
    dio.httpClientAdapter = Adapter((request) async {
      if (request.path.endsWith('/refresh')) {
        refreshes++;
        return jsonBody(200, {
          'access_token': 'new',
          'refresh_token': 'refresh-new',
        });
      }
      return jsonBody(401, {});
    });
    await expectLater(
      dio.get<Object?>('/resource'),
      throwsA(isA<DioException>()),
    );
    expect(refreshes, 1);
    expect(store.tokens, isNull);
  });
  test('a late 401 from a previous login is never replayed against another account', () async {
    final entered = Completer<void>();
    final release = Completer<void>();
    var calls = 0;
    dio.httpClientAdapter = Adapter((request) async {
      calls++;
      entered.complete();
      await release.future;
      return jsonBody(401, {});
    });
    final request = dio.post<Object?>(
      '/resource',
      data: {'write': 'old-account'},
    );
    final expectation = expectLater(request, throwsA(isA<DioException>()));
    await entered.future;
    await store.save(
      const AuthTokens(
        accessToken: 'another-account',
        refreshToken: 'another-refresh',
      ),
    );
    release.complete();
    await expectation;
    expect(calls, 1);
    expect(store.tokens?.accessToken, 'another-account');
  });
}
