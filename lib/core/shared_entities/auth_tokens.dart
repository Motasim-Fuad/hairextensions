import 'package:equatable/equatable.dart';

/// The API issues a single bearer token at login. There is no refresh token:
/// when the token expires the stylist signs in again.
class AuthTokens extends Equatable {
  const AuthTokens({required this.accessToken, this.expiresAt});

  final String accessToken;
  final DateTime? expiresAt;

  bool isExpired(DateTime now) {
    final expiry = expiresAt;
    return expiry != null && !expiry.isAfter(now);
  }

  @override
  List<Object?> get props => [accessToken, expiresAt];
}
