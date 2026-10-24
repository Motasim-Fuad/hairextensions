import 'package:hairextensions/core/shared_entities/auth_tokens.dart';

/// Matches the FastAPI OAuth2 token response.
class AuthTokensModel {
  const AuthTokensModel({required this.accessToken, required this.refreshToken, this.expiresInSeconds});

  factory AuthTokensModel.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    return AuthTokensModel(
      accessToken: map[_accessTokenKey] as String,
      refreshToken: map[_refreshTokenKey] as String,
      expiresInSeconds: (map[_expiresInKey] as num?)?.toInt(),
    );
  }

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresInKey = 'expires_in';

  final String accessToken;
  final String refreshToken;
  final int? expiresInSeconds;

  AuthTokens toEntity(DateTime now) {
    final expiresIn = expiresInSeconds;
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresIn == null ? null : now.add(Duration(seconds: expiresIn)),
    );
  }
}
