import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/analytics/analytics_event.dart';
import 'package:hairextensions/core/analytics/analytics_service.dart';
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';

/// Debug builds log events locally and never send them. Events raised before
/// Firebase starts are buffered until consent is applied.
@LazySingleton(as: AnalyticsService)
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._firebase);

  static const String _source = 'Analytics';
  static const int _maxPending = 50;

  final FirebaseBootstrapper _firebase;
  final List<AnalyticsEvent> _pending = [];
  bool _enabled = false;

  bool get _canSend => _firebase.isReady && _enabled && !kDebugMode;

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {
    _enabled = enabled;
    if (!_firebase.isReady) {
      return;
    }
    final analytics = FirebaseAnalytics.instance;
    final allowed = enabled && !kDebugMode;
    await analytics.setConsent(analyticsStorageConsentGranted: allowed, adStorageConsentGranted: false);
    await analytics.setAnalyticsCollectionEnabled(allowed);
    if (!allowed) {
      _pending.clear();
      return;
    }
    final queued = List.of(_pending);
    _pending.clear();
    for (final event in queued) {
      await _send(event);
    }
  }

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    if (kDebugMode) {
      AppLogger.debug(_source, '${event.name} ${event.parameters}');
      return;
    }
    if (_canSend) {
      await _send(event);
      return;
    }
    if (!_firebase.isReady && _pending.length < _maxPending) {
      _pending.add(event);
    }
  }

  @override
  Future<void> logScreenView(String screenName) async {
    if (kDebugMode) {
      AppLogger.debug(_source, 'screen $screenName');
      return;
    }
    if (_canSend) {
      await FirebaseAnalytics.instance.logScreenView(screenName: screenName);
    }
  }

  @override
  Future<void> setUserId(String? id) async {
    if (_firebase.isReady && !kDebugMode) {
      await FirebaseAnalytics.instance.setUserId(id: id);
    }
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (_firebase.isReady && !kDebugMode) {
      await FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
    }
  }

  @override
  Future<void> reset() async {
    _pending.clear();
    if (_firebase.isReady) {
      await FirebaseAnalytics.instance.resetAnalyticsData();
    }
  }

  Future<void> _send(AnalyticsEvent event) {
    return FirebaseAnalytics.instance.logEvent(
      name: event.name,
      parameters: event.parameters.isEmpty ? null : event.parameters,
    );
  }
}
