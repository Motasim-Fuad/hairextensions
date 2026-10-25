import 'package:hairextensions/core/shared_entities/auth_tokens.dart';

/// Matches the API `TokenResponse`:
/// {access_token, token_type, expires_at, user: {id, email, name, ...}}.
class AuthTokensModel {
  const AuthTokensModel({required this.accessToken, this.expiresAt, this.userName, this.userEmail});

  factory AuthTokensModel.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    final user = map[_userKey];
    return AuthTokensModel(
      accessToken: map[_accessTokenKey] as String,
      expiresAt: DateTime.tryParse('${map[_expiresAtKey] ?? ''}'),
      userName: user is Map ? user[_nameKey] as String? : null,
      userEmail: user is Map ? user[_emailKey] as String? : null,
    );
  }

  static const String _accessTokenKey = 'access_token';
  static const String _expiresAtKey = 'expires_at';
  static const String _userKey = 'user';
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';

  final String accessToken;
  final DateTime? expiresAt;
  final String? userName;
  final String? userEmail;

  AuthTokens toEntity() => AuthTokens(accessToken: accessToken, expiresAt: expiresAt?.toUtc());
}
