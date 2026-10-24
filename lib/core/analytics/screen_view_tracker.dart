import 'dart:async';

import 'package:hairextensions/core/analytics/analytics_service.dart';
import 'package:injectable/injectable.dart';

/// Single funnel for screen views. A tab switch is seen by both the shell
/// and the tab's navigator observer, so a repeat of the last screen is dropped.
@lazySingleton
class ScreenViewTracker {
  ScreenViewTracker(this._analytics);

  final AnalyticsService _analytics;
  String? _last;

  void track(String screenName) {
    if (screenName == _last) {
      return;
    }
    _last = screenName;
    unawaited(_analytics.logScreenView(screenName));
  }
}
