import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/http_status_codes.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/network/auth/token_refresher.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';

/// On 401 performs exactly one refresh no matter how many requests fail at the
/// same time. Every failed request awaits the same in-flight future and is then
/// replayed with the new token. A rejected refresh clears tokens and signals
/// expiry; an unreachable server keeps the session and passes the error on.
///
/// A plain Interceptor is used on purpose: a QueuedInterceptor would deadlock
/// when the replayed request itself fails while the queue is still busy.
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required this._dio,
    required this._tokenStore,
    required this._refresher,
    required this._expiryNotifier,
  });

  static const String _source = 'TokenRefreshInterceptor';

  final Dio _dio;
  final SecureTokenStore _tokenStore;
  final TokenRefresher _refresher;
  final SessionExpiryNotifier _expiryNotifier;
  Future<AuthTokens?>? _inFlight;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (!_shouldHandle(err)) {
      handler.next(err);
      return;
    }
    final current = await _tokenStore.read();
    if (current == null) {
      await _expire();
      handler.next(err);
      return;
    }
    final failedToken = _bearerTokenOf(request);
    final AuthTokens? tokens;
    try {
      tokens = current.accessToken == failedToken ? await _refreshOnce(current.refreshToken) : current;
    } on Object catch (error) {
      AppLogger.warning(_source, 'refresh unavailable, keeping session $error');
      handler.next(err);
      return;
    }
    if (tokens == null) {
      await _expire();
      handler.next(err);
      return;
    }
    try {
      final replayed = await _dio.fetch<Object?>(
        request.copyWith(
          headers: {
            ...request.headers,
            NetworkConstants.authorizationHeader: '${NetworkConstants.bearerPrefix}${tokens.accessToken}',
          },
          extra: {
            ...request.extra,
            NetworkConstants.retriedAfterRefreshKey: true,
          },
        ),
      );
      handler.resolve(replayed);
    } on DioException catch (replayError) {
      handler.next(replayError);
    }
  }

  bool _shouldHandle(DioException err) {
    final extra = err.requestOptions.extra;
    return err.response?.statusCode == HttpStatusCodes.unauthorized &&
        extra[NetworkConstants.retriedAfterRefreshKey] != true &&
        extra[NetworkConstants.skipAuthKey] != true;
  }

  Future<AuthTokens?> _refreshOnce(String refreshToken) {
    return _inFlight ??= _refresh(
      refreshToken,
    ).whenComplete(() => _inFlight = null);
  }

  /// Throws when the refresh could not be attempted; null means rejected.
  Future<AuthTokens?> _refresh(String refreshToken) async {
    AppLogger.debug(_source, 'refreshing access token');
    final tokens = await _refresher.refresh(refreshToken);
    if (tokens != null) {
      await _tokenStore.save(tokens);
    }
    return tokens;
  }

  Future<void> _expire() async {
    AppLogger.warning(_source, 'session expired');
    await _tokenStore.clear();
    _expiryNotifier.notifyExpired();
  }

  String? _bearerTokenOf(RequestOptions request) {
    final header = request.headers[NetworkConstants.authorizationHeader];
    if (header is! String || !header.startsWith(NetworkConstants.bearerPrefix)) {
      return null;
    }
    return header.substring(NetworkConstants.bearerPrefix.length);
  }
}
