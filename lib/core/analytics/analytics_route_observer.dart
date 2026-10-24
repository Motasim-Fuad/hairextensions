import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/analytics/screen_view_tracker.dart';

/// Logs screen views for named page routes. Dialogs and sheets are ignored.
/// An observer can only be attached to one navigator, so create one per
/// navigator.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._tracker);

  final ScreenViewTracker _tracker;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _log(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _log(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _log(previousRoute);
  }

  void _log(Route<dynamic>? route) {
    if (route is! PageRoute<dynamic>) {
      return;
    }
    final name = route.settings.name;
    if (name == null || name.isEmpty) {
      return;
    }
    _tracker.track(name);
  }
}
