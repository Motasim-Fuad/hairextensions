import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';

/// Coalesces concurrent 401s, rotates tokens and retries each request once.
/// Network/5xx failures preserve the session so an offline user can retry.
class SessionExpiryInterceptor extends Interceptor {
  SessionExpiryInterceptor({
    Dio? dio,
    required SecureTokenStore tokenStore,
    required SessionExpiryNotifier expiryNotifier,
  }) : _dio = dio,
       _tokenStore = tokenStore,
       _expiryNotifier = expiryNotifier;

  final Dio? _dio;
  final SecureTokenStore _tokenStore;
  final SessionExpiryNotifier _expiryNotifier;
  Future<AuthTokens?>? _refreshing;
  final Map<String, String> _rotations = {};
  static const _retried = 'sessionRefreshRetried';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final authorization = request.headers[NetworkConstants.authorizationHeader];
    if (err.response?.statusCode == 401 && request.extra[_retried] == true) {
      final rejected = await _tokenStore.read();
      if (rejected != null &&
          authorization ==
              '${NetworkConstants.bearerPrefix}${rejected.accessToken}') {
        await _expire(rejected);
      }
      handler.next(err);
      return;
    }
    if (err.response?.statusCode != 401 ||
        request.extra[NetworkConstants.skipAuthKey] == true ||
        authorization is! String ||
        request.extra[_retried] == true) {
      handler.next(err);
      return;
    }
    try {
      final before = await _tokenStore.read();
      if (before == null) {
        handler.next(err);
        return;
      }
      final failed = authorization.startsWith(NetworkConstants.bearerPrefix)
          ? authorization.substring(NetworkConstants.bearerPrefix.length)
          : '';
      if (failed != before.accessToken &&
          !_isRotationOf(failed, before.accessToken)) {
        // A response belonging to another login must never replay its writes
        // using the credentials of the newly signed-in account.
        handler.next(err);
        return;
      }
      AuthTokens? renewed = before;
      if (authorization ==
          '${NetworkConstants.bearerPrefix}${before.accessToken}') {
        final pending = _refreshing ??= _refresh(before);
        try {
          renewed = await pending;
        } finally {
          if (identical(_refreshing, pending)) _refreshing = null;
        }
      }
      if (renewed == null || _dio == null) {
        handler.next(err);
        return;
      }
      // Do not resurrect a session that was logged out while refresh ran.
      if ((await _tokenStore.read())?.accessToken != renewed.accessToken) {
        handler.next(err);
        return;
      }
      request.extra[_retried] = true;
      request.headers[NetworkConstants.authorizationHeader] =
          '${NetworkConstants.bearerPrefix}${renewed.accessToken}';
      if (request.data is FormData)
        request.data = (request.data as FormData).clone();
      final response = await _dio.fetch<Object?>(request);
      handler.resolve(response);
    } on DioException catch (failure) {
      handler.next(failure);
    } on Object {
      handler.next(err);
    }
  }

  Future<AuthTokens?> _refresh(AuthTokens before) async {
    final refreshToken = before.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty || _dio == null) {
      await _expire(before);
      return null;
    }
    // Separate transport avoids recursing through this interceptor.
    final bare = Dio(_dio.options.copyWith());
    bare.httpClientAdapter = _dio.httpClientAdapter;
    try {
      final response = await bare.post<Map<String, dynamic>>(
        '${NetworkConstants.apiPrefix}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data!;
      final renewed = AuthTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        expiresAt: DateTime.tryParse('${data['expires_at']}'),
      );
      if ((await _tokenStore.read())?.accessToken != before.accessToken)
        return null;
      _rotations[before.accessToken] = renewed.accessToken;
      if (_rotations.length > 32) _rotations.remove(_rotations.keys.first);
      await _tokenStore.save(renewed);
      return renewed;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        await _expire(before);
      }
      rethrow;
    }
  }

  bool _isRotationOf(String failed, String current) {
    var candidate = failed;
    for (var i = 0; i < 32; i++) {
      final next = _rotations[candidate];
      if (next == null) return false;
      if (next == current) return true;
      candidate = next;
    }
    return false;
  }

  Future<void> _expire(AuthTokens before) async {
    if ((await _tokenStore.read())?.accessToken == before.accessToken) {
      await _tokenStore.clear();
      _expiryNotifier.notifyExpired();
    }
  }
}
