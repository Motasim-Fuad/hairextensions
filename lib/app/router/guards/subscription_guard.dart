import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:injectable/injectable.dart';

/// The paywall is opened explicitly from Settings only.
@lazySingleton
class SubscriptionGuard implements RouteGuard {
  SubscriptionGuard(SubscriptionService subscription, FeatureFlagService flags);
  @override
  String? redirect(Uri location) => null;
}
