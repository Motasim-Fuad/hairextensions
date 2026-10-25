import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/remote_config_keys.dart';

abstract final class FeatureFlagDefaults {
  static const String baselineVersion = '1.0.0';

  static Map<String, Object> get all => {
    for (final key in FeatureKey.values) key.remoteKey: key.defaultEnabled,
    RemoteConfigKeys.minSupportedVersion: baselineVersion,
    RemoteConfigKeys.latestVersion: baselineVersion,
    RemoteConfigKeys.maintenanceMode: false,
    RemoteConfigKeys.maintenanceMessage: '',
    RemoteConfigKeys.storeUrlAndroid: '',
    RemoteConfigKeys.storeUrlIos: '',
    RemoteConfigKeys.termsUrl: '',
    RemoteConfigKeys.privacyUrl: '',
    RemoteConfigKeys.supportEmail: '',
    RemoteConfigKeys.supportWhatsapp: '',
  };

  static Map<String, String> get asStrings => all.map((key, value) => MapEntry(key, '$value'));
}
