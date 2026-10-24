import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_source.dart';
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';

/// Fetch-on-demand only. The realtime listener is not used because it keeps a
/// long-lived connection open, which costs battery for little benefit here.
@LazySingleton(as: FeatureFlagSource)
class FirebaseRemoteConfigSource implements FeatureFlagSource {
  FirebaseRemoteConfigSource(this._firebase);

  static const String _source = 'RemoteConfig';
  static const Duration _fetchTimeout = Duration(seconds: 10);
  static const Duration _releaseFetchInterval = Duration(hours: 12);
  static const Duration _debugFetchInterval = Duration(minutes: 5);

  final FirebaseBootstrapper _firebase;
  bool _configured = false;

  @override
  Future<Map<String, String>?> fetch({
    required Map<String, Object> defaults,
    required Map<String, Object> customSignals,
  }) async {
    if (!await _firebase.whenReady) {
      return null;
    }
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      if (!_configured) {
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: _fetchTimeout,
            minimumFetchInterval: kDebugMode ? _debugFetchInterval : _releaseFetchInterval,
          ),
        );
        await remoteConfig.setDefaults(defaults);
        _configured = true;
      }
      if (customSignals.isNotEmpty) {
        await remoteConfig.setCustomSignals(customSignals);
      }
      await remoteConfig.fetchAndActivate();
    } on Object catch (error) {
      AppLogger.warning(_source, 'fetch failed $error');
      if (!_configured) {
        return null;
      }
    }
    return remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()));
  }
}
