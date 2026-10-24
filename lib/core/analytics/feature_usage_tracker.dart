import 'dart:async';

import 'package:hairextensions/core/analytics/analytics_event.dart';
import 'package:hairextensions/core/analytics/analytics_event_names.dart';
import 'package:hairextensions/core/analytics/analytics_params.dart';
import 'package:hairextensions/core/analytics/analytics_service.dart';
import 'package:hairextensions/core/analytics/feature_session.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:injectable/injectable.dart';

/// Frequency comes from feature_opened and feature_used counts; duration from
/// feature_session. Segment by the user properties in Analytics.
@lazySingleton
class FeatureUsageTracker {
  FeatureUsageTracker(this._analytics);

  final AnalyticsService _analytics;

  void opened(FeatureKey feature, {String? source}) {
    _log(
      AnalyticsEvent(AnalyticsEventNames.featureOpened, {
        AnalyticsParams.feature: feature.analyticsName,
        AnalyticsParams.source: ?source,
      }),
    );
  }

  void used(FeatureKey feature, String action) {
    _log(
      AnalyticsEvent(AnalyticsEventNames.featureUsed, {
        AnalyticsParams.feature: feature.analyticsName,
        AnalyticsParams.action: action,
      }),
    );
  }

  FeatureSession startSession(FeatureKey feature) => FeatureSession(feature, _onSessionEnd);

  void _onSessionEnd(FeatureKey feature, Duration duration) {
    _log(
      AnalyticsEvent(AnalyticsEventNames.featureSession, {
        AnalyticsParams.feature: feature.analyticsName,
        AnalyticsParams.durationMs: duration.inMilliseconds,
      }),
    );
  }

  void _log(AnalyticsEvent event) => unawaited(_analytics.logEvent(event));
}
