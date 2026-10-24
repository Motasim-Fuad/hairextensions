/// Thrown by a TokenRefresher when the refresh could not be attempted, for
/// example while offline. The session is kept instead of being ended.
class TokenRefreshUnavailableException implements Exception {
  const TokenRefreshUnavailableException(this.reason);

  final String reason;

  @override
  String toString() => 'TokenRefreshUnavailableException: $reason';
}
