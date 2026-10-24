import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';
import 'package:hairextensions/core/feature_flags/beta_targeting.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_cache.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/remote_config_keys.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes/in_memory_key_value_store.dart';
import '../../helpers/mocks/mock_analytics_service.dart';
import '../../helpers/mocks/mock_feature_flag_source.dart';

void main() {
  late MockFeatureFlagSource source;
  late InMemoryKeyValueStore store;

  FeatureFlagService build() {
    return FeatureFlagService(source, FeatureFlagCache(store), BetaTargeting(store, MockAnalyticsService()));
  }

  void stubFetch(Map<String, String>? result) {
    when(
      () => source.fetch(
        defaults: any(named: 'defaults'),
        customSignals: any(named: 'customSignals'),
      ),
    ).thenAnswer((_) async => result);
  }

  setUp(() {
    source = MockFeatureFlagSource();
    store = InMemoryKeyValueStore({StorageKeys.deviceId: 'device-1'});
  });

  test('uses bundled defaults before any fetch', () {
    final service = build();
    for (final key in FeatureKey.values) {
      expect(service.isEnabled(key), key.defaultEnabled, reason: key.name);
    }
  });

  test('cached remote values override defaults on cold start', () {
    store = InMemoryKeyValueStore({
      StorageKeys.featureFlagsCache: jsonEncode({FeatureKey.invoices.remoteKey: 'false'}),
    });
    expect(build().isEnabled(FeatureKey.invoices), isFalse);
  });

  test('refresh applies, persists and notifies once on change', () async {
    stubFetch({FeatureKey.cloudSync.remoteKey: 'true', RemoteConfigKeys.minSupportedVersion: '2.1.0'});
    final service = build();
    var notifications = 0;
    service.addListener(() => notifications++);

    await service.refresh();

    expect(service.isEnabled(FeatureKey.cloudSync), isTrue);
    expect(service.appStatus.minSupportedVersion, const AppVersion(2, 1, 0));
    expect(notifications, 1);
    expect(store.peekString(StorageKeys.featureFlagsCache), contains(FeatureKey.cloudSync.remoteKey));

    await service.refresh();
    expect(notifications, 1);
  });

  test('failed fetch keeps current values and does not notify', () async {
    stubFetch(null);
    final service = build();
    var notifications = 0;
    service.addListener(() => notifications++);

    await service.refresh();

    expect(service.isEnabled(FeatureKey.quoteBuilder), isTrue);
    expect(notifications, 0);
  });

  test('sends targeting signals with the fetch', () async {
    stubFetch(const {});
    await build().refresh();

    final captured =
        verify(
              () => source.fetch(
                defaults: any(named: 'defaults'),
                customSignals: captureAny(named: 'customSignals'),
              ),
            ).captured.single
            as Map<String, Object>;
    expect(captured[RemoteConfigKeys.signalUserId], 'device-1');
  });

  test('concurrent refresh calls share one fetch', () async {
    stubFetch(const {});
    final service = build();
    await Future.wait([service.refresh(), service.refresh()]);
    verify(
      () => source.fetch(
        defaults: any(named: 'defaults'),
        customSignals: any(named: 'customSignals'),
      ),
    ).called(1);
  });

  test('unparseable boolean falls back to the key default', () {
    store = InMemoryKeyValueStore({
      StorageKeys.featureFlagsCache: jsonEncode({FeatureKey.library.remoteKey: 'maybe'}),
    });
    expect(build().isEnabled(FeatureKey.library), FeatureKey.library.defaultEnabled);
  });
}
