import 'package:hairextensions/core/shared_entities/auth_tokens.dart';

/// Implemented by the auth feature. Returns null when the refresh token is
/// rejected, which ends the session. Throws TokenRefreshUnavailableException
/// when the server could not be reached, which keeps the session.
abstract interface class TokenRefresher {
  Future<AuthTokens?> refresh(String refreshToken);
}
