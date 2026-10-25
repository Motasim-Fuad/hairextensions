import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/feature_flags/app_links_config.dart';
import 'package:hairextensions/core/feature_flags/app_status_config.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';
import 'package:hairextensions/core/feature_flags/beta_targeting.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_cache.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_defaults.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_source.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/remote_config_keys.dart';
import 'package:injectable/injectable.dart';

/// Reads are synchronous from memory: bundled defaults overlaid with the last
/// cached remote values. [refresh] runs after the first frame and notifies
/// listeners, such as the router, only when something actually changed.
@lazySingleton
class FeatureFlagService extends ChangeNotifier {
  FeatureFlagService(this._source, this._cache, this._targeting);

  final FeatureFlagSource _source;
  final FeatureFlagCache _cache;
  final BetaTargeting _targeting;

  Map<String, String>? _values;
  Future<void>? _refreshing;

  Map<String, String> get _current => _values ??= {...FeatureFlagDefaults.asStrings, ..._cache.read()};

  bool isEnabled(FeatureKey key) => boolValue(key.remoteKey, fallback: key.defaultEnabled);

  bool boolValue(String key, {bool fallback = false}) {
    final raw = _current[key]?.trim().toLowerCase();
    return switch (raw) {
      'true' || '1' => true,
      'false' || '0' => false,
      _ => fallback,
    };
  }

  String stringValue(String key) => _current[key] ?? '';

  AppStatusConfig get appStatus => AppStatusConfig(
    minSupportedVersion: AppVersion.tryParse(stringValue(RemoteConfigKeys.minSupportedVersion)) ?? AppVersion.zero,
    latestVersion: AppVersion.tryParse(stringValue(RemoteConfigKeys.latestVersion)) ?? AppVersion.zero,
    maintenanceEnabled: boolValue(RemoteConfigKeys.maintenanceMode),
    maintenanceMessage: stringValue(RemoteConfigKeys.maintenanceMessage),
    storeUrl: stringValue(
      defaultTargetPlatform == TargetPlatform.iOS ? RemoteConfigKeys.storeUrlIos : RemoteConfigKeys.storeUrlAndroid,
    ),
  );

  AppLinksConfig get links => AppLinksConfig(
    termsUrl: stringValue(RemoteConfigKeys.termsUrl).trim(),
    privacyUrl: stringValue(RemoteConfigKeys.privacyUrl).trim(),
    supportEmail: stringValue(RemoteConfigKeys.supportEmail).trim(),
    supportWhatsapp: stringValue(RemoteConfigKeys.supportWhatsapp).trim(),
  );

  /// Concurrent callers share one fetch.
  Future<void> refresh() => _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<void> _refresh() async {
    final fetched = await _source.fetch(
      defaults: FeatureFlagDefaults.all,
      customSignals: _targeting.customSignals,
    );
    if (fetched == null) {
      return;
    }
    final merged = {...FeatureFlagDefaults.asStrings, ...fetched};
    if (mapEquals(merged, _current)) {
      return;
    }
    _values = merged;
    await _cache.write(fetched);
    notifyListeners();
  }
}
