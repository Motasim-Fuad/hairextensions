import 'dart:convert';

import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/feature_flags/beta_targeting.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_cache.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';

import 'fakes/in_memory_key_value_store.dart';
import 'mocks/mock_analytics_service.dart';
import 'mocks/mock_feature_flag_source.dart';

/// A real flag service whose cached remote values are `overrides`.
abstract final class TestFeatureFlags {
  static FeatureFlagService build({Map<FeatureKey, bool> overrides = const {}}) {
    final store = InMemoryKeyValueStore({
      StorageKeys.featureFlagsCache: jsonEncode({
        for (final entry in overrides.entries) entry.key.remoteKey: '${entry.value}',
      }),
    });
    return FeatureFlagService(
      MockFeatureFlagSource(),
      FeatureFlagCache(store),
      BetaTargeting(store, MockAnalyticsService()),
    );
  }
}
