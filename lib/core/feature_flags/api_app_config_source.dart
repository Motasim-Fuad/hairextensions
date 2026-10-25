import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_source.dart';
import 'package:hairextensions/core/feature_flags/firebase_remote_config_source.dart';
import 'package:hairextensions/core/feature_flags/remote_config_keys.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:injectable/injectable.dart';

/// Feature switches still come from Firebase Remote Config. Maintenance mode,
/// the minimum and latest app version and the legal and support links come
/// from the backend (`GET /v1/app-config`) and win over Firebase for those keys.
@LazySingleton(as: FeatureFlagSource)
class ApiAppConfigSource implements FeatureFlagSource {
  ApiAppConfigSource(this._firebase, this._client, this._config);

  static const String _source = 'AppConfigSource';
  static const String _path = '${NetworkConstants.apiPrefix}/app-config';

  final FirebaseRemoteConfigSource _firebase;
  final ApiClient _client;
  final AppConfig _config;

  @override
  Future<Map<String, String>?> fetch({
    required Map<String, Object> defaults,
    required Map<String, Object> customSignals,
  }) async {
    final fromFirebase = await _firebase.fetch(defaults: defaults, customSignals: customSignals);
    if (!_config.environment.usesRemoteApi) {
      return fromFirebase;
    }
    final response = await _client.get<Map<String, String>>(_path, parser: _parse);
    final fromApi = response.data;
    if (!response.isSuccess || fromApi == null) {
      AppLogger.warning(_source, 'app-config unavailable ${response.statusCode}');
      return fromFirebase;
    }
    return {...?fromFirebase, ...fromApi};
  }

  static Map<String, String> _parse(Object? json) {
    final map = json! as Map<String, dynamic>;
    String text(String key) => (map[key] as String?)?.trim() ?? '';
    return {
      RemoteConfigKeys.minSupportedVersion: text('minimum_app_version'),
      RemoteConfigKeys.latestVersion: text('latest_app_version'),
      RemoteConfigKeys.maintenanceMode: '${map['maintenance_mode'] == true}',
      RemoteConfigKeys.maintenanceMessage: text('maintenance_message'),
      RemoteConfigKeys.termsUrl: text('terms_url'),
      RemoteConfigKeys.privacyUrl: text('privacy_url'),
      RemoteConfigKeys.supportEmail: text('support_email'),
      RemoteConfigKeys.supportWhatsapp: text('support_whatsapp'),
    };
  }
}
