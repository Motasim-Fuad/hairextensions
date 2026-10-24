abstract final class NetworkConstants {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
  static const int maxRetries = 3;
  static const Duration retryBaseDelay = Duration(milliseconds: 400);
  static const Duration retryMaxDelay = Duration(seconds: 8);
  static const Duration mockLatency = Duration(milliseconds: 600);
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String acceptHeader = 'Accept';
  static const String jsonContentType = 'application/json';
  static const String skipAuthKey = 'skipAuth';
  static const String retriedAfterRefreshKey = 'retriedAfterRefresh';
  static const String retryAttemptKey = 'retryAttempt';
  static const String requestStartedAtKey = 'requestStartedAt';
  static const String httpMetricKey = 'httpMetric';

  /// Request extra holding the FeatureKey analytics name for per-feature
  /// network traces.
  static const String featureKey = 'feature';
  static const String refreshPath = '/auth/refresh';
  static const int maxPlainErrorLength = 200;
}
