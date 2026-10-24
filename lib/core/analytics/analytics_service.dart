import 'package:hairextensions/core/analytics/analytics_event.dart';

abstract interface class AnalyticsService {
  /// Enabling flushes events captured before Firebase was ready; disabling
  /// discards them and revokes analytics storage consent.
  Future<void> setCollectionEnabled({required bool enabled});

  Future<void> logEvent(AnalyticsEvent event);

  Future<void> logScreenView(String screenName);

  Future<void> setUserId(String? id);

  Future<void> setUserProperty(String name, String? value);

  Future<void> reset();
}
