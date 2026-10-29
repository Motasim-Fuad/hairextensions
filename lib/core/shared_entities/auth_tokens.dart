import 'package:equatable/equatable.dart';

/// Session pair returned by login and refresh. Refresh tokens stay in secure storage.
class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  bool isExpired(DateTime now) {
    final expiry = expiresAt;
    return expiry != null && !expiry.isAfter(now);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}
