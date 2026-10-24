import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore);

  final SecureTokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[NetworkConstants.skipAuthKey] == true) {
      handler.next(options);
      return;
    }
    final token = _tokenStore.cachedAccessToken ?? (await _tokenStore.read())?.accessToken;
    if (token != null) {
      options.headers[NetworkConstants.authorizationHeader] = '${NetworkConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }
}
