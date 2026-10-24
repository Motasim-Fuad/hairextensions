import 'package:hairextensions/core/cache/cached_payload.dart';

/// Stores raw JSON of remote reads with an expiry. Expired entries are still
/// returned (flagged) so the UI can show stale data while offline.
abstract interface class ApiCacheStore {
  Future<CachedPayload?> read(String key);

  Future<void> write(String key, String payload, Duration ttl);

  Future<void> invalidate(String key);

  Future<void> purgeExpired();
}
