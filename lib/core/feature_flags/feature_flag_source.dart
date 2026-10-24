abstract interface class FeatureFlagSource {
  /// Fetches and activates remote values. Returns null when the backend is
  /// unavailable so callers keep the last known values.
  Future<Map<String, String>?> fetch({
    required Map<String, Object> defaults,
    required Map<String, Object> customSignals,
  });
}
