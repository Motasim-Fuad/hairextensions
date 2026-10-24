import 'package:hairextensions/core/shared_entities/auth_tokens.dart';

abstract interface class SecureTokenStore {
  /// Last known access token held in memory to avoid a keychain read per request.
  String? get cachedAccessToken;

  Future<AuthTokens?> read();

  Future<void> save(AuthTokens tokens);

  Future<void> clear();
}
