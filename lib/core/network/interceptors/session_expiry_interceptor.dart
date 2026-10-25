import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/http_status_codes.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';

/// The API has no refresh endpoint, so a 401 on an authenticated request means
/// the bearer token is expired or revoked. Tokens are cleared and the expiry
/// notifier tells the auth layer to end the session and send the user to login.
class SessionExpiryInterceptor extends Interceptor {
  SessionExpiryInterceptor({required SecureTokenStore tokenStore, required SessionExpiryNotifier expiryNotifier})
    : _tokenStore = tokenStore,
      _expiryNotifier = expiryNotifier;

  static const String _source = 'SessionExpiryInterceptor';

  final SecureTokenStore _tokenStore;
  final SessionExpiryNotifier _expiryNotifier;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final header = err.requestOptions.headers[NetworkConstants.authorizationHeader];
    final failedToken = header is String && header.startsWith(NetworkConstants.bearerPrefix)
        ? header.substring(NetworkConstants.bearerPrefix.length)
        : null;
    if (err.response?.statusCode == HttpStatusCodes.unauthorized &&
        extra[NetworkConstants.skipAuthKey] != true &&
        failedToken != null) {
      // A slow request that started with an older token must not end a session
      // the user has just opened with a new one.
      final current = (await _tokenStore.read())?.accessToken;
      if (current == failedToken) {
        AppLogger.warning(_source, 'bearer token rejected, ending session');
        await _tokenStore.clear();
        _expiryNotifier.notifyExpired();
      }
    }
    handler.next(err);
  }
}
