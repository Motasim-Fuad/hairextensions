import 'dart:async';

import 'package:hairextensions/core/analytics/analytics_service.dart';
import 'package:hairextensions/core/analytics/analytics_user_properties.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/feature_flags/remote_config_keys.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:injectable/injectable.dart';

/// Supplies the identity Remote Config conditions target. Custom signals are
/// evaluated on the next fetch; Analytics user properties drive audiences
/// and percentage rollouts by segment.
@lazySingleton
class BetaTargeting {
  BetaTargeting(this._store, this._analytics);

  final KeyValueStore _store;
  final AnalyticsService _analytics;
  String? _appVersion;

  String? get userId => _store.peekString(StorageKeys.deviceId);

  String? get betaCohort => _store.peekString(StorageKeys.betaCohort);

  Map<String, Object> get customSignals => {
    RemoteConfigKeys.signalUserId: ?userId,
    RemoteConfigKeys.signalBetaCohort: ?betaCohort,
    RemoteConfigKeys.signalAppVersion: ?_appVersion,
  };

  Future<void> identify({required String appVersion}) async {
    _appVersion = appVersion;
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(AnalyticsUserProperties.appVersion, appVersion);
    await _analytics.setUserProperty(AnalyticsUserProperties.betaCohort, betaCohort);
  }

  /// Called from a beta invite deep link. Takes effect on the next fetch.
  Future<void> joinCohort(String? cohort) async {
    if (cohort == null || cohort.isEmpty) {
      await _store.remove(StorageKeys.betaCohort);
    } else {
      await _store.setString(StorageKeys.betaCohort, cohort);
    }
    unawaited(_analytics.setUserProperty(AnalyticsUserProperties.betaCohort, cohort));
  }
}
