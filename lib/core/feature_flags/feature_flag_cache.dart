import 'dart:convert';

import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:injectable/injectable.dart';

/// Last activated values, so a cold start without network still honours the
/// most recent remote decision.
@lazySingleton
class FeatureFlagCache {
  FeatureFlagCache(this._store);

  static const String _source = 'FeatureFlagCache';

  final KeyValueStore _store;

  Map<String, String> read() {
    final raw = _store.peekString(StorageKeys.featureFlagsCache);
    if (raw == null || raw.isEmpty) {
      return const {};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const {};
      }
      return decoded.map((key, value) => MapEntry(key, '$value'));
    } on FormatException catch (error) {
      AppLogger.warning(_source, 'corrupt cache $error');
      return const {};
    }
  }

  Future<void> write(Map<String, String> values) {
    return _store.setString(StorageKeys.featureFlagsCache, jsonEncode(values));
  }
}
