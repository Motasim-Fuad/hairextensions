import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:injectable/injectable.dart';

/// Pro-only routes send free users to the paywall. In-app entry points show
/// the lock sheet first; this catches deep links. Turning the subscriptions
/// flag off makes everything free.
@lazySingleton
class SubscriptionGuard implements RouteGuard {
  SubscriptionGuard(this._subscription, this._flags);

  final SubscriptionService _subscription;
  final FeatureFlagService _flags;

  @override
  String? redirect(Uri location) {
    final path = location.path;
    final hasPro = _subscription.isPro || !_flags.isEnabled(FeatureKey.subscriptions);
    if (RouteAccess.matches(path, AppRoutes.paywallPath)) {
      return _subscription.isPro ? AppRoutes.homePath : null;
    }
    if (!hasPro && RouteAccess.matchesAny(path, RouteAccess.proOnlyPaths)) {
      return AppRoutes.paywallPath;
    }
    return null;
  }
}
