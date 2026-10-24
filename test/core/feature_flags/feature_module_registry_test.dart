import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/feature_flags/beta_targeting.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_cache.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/feature_module.dart';
import 'package:hairextensions/core/feature_flags/feature_module_registry.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes/in_memory_key_value_store.dart';
import '../../helpers/mocks/mock_analytics_service.dart';
import '../../helpers/mocks/mock_feature_flag_source.dart';

class _CountingModule implements FeatureModule {
  _CountingModule(this.feature);

  @override
  final FeatureKey feature;

  int initializations = 0;

  @override
  Future<void> initialize() async => initializations++;
}

void main() {
  test('initializes only enabled modules, then late-enabled ones once', () async {
    final source = MockFeatureFlagSource();
    when(
      () => source.fetch(
        defaults: any(named: 'defaults'),
        customSignals: any(named: 'customSignals'),
      ),
    ).thenAnswer((_) async => {FeatureKey.cloudSync.remoteKey: 'true'});
    final store = InMemoryKeyValueStore({
      StorageKeys.featureFlagsCache: jsonEncode({FeatureKey.cloudSync.remoteKey: 'false'}),
    });
    final flags = FeatureFlagService(source, FeatureFlagCache(store), BetaTargeting(store, MockAnalyticsService()));
    final enabled = _CountingModule(FeatureKey.quoteBuilder);
    final disabled = _CountingModule(FeatureKey.cloudSync);
    final registry = FeatureModuleRegistry(flags)..registerAll([enabled, disabled]);

    await registry.initializeEnabled();
    expect(enabled.initializations, 1);
    expect(disabled.initializations, 0);

    await flags.refresh();
    await pumpEventQueue();
    expect(disabled.initializations, 1);
    expect(enabled.initializations, 1);

    registry.dispose();
  });
}
