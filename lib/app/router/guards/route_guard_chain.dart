import 'package:flutter/foundation.dart';
import 'package:hairextensions/app/router/guards/app_gate_guard.dart';
import 'package:hairextensions/app/router/guards/auth_guard.dart';
import 'package:hairextensions/app/router/guards/feature_flag_guard.dart';
import 'package:hairextensions/app/router/guards/onboarding_guard.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/app/router/guards/setup_guard.dart';
import 'package:hairextensions/app/router/guards/subscription_guard.dart';
import 'package:injectable/injectable.dart';

/// Runs guards in priority order and returns the first redirect. go_router
/// re-runs the chain on the new location, so each guard only needs one step.
@lazySingleton
class RouteGuardChain {
  RouteGuardChain(
    AppGateGuard gate,
    OnboardingGuard onboarding,
    AuthGuard auth,
    SetupGuard setup,
    FeatureFlagGuard featureFlags,
    SubscriptionGuard subscription,
  ) : _guards = [gate, onboarding, auth, setup, featureFlags, subscription];

  @visibleForTesting
  RouteGuardChain.of(this._guards);

  final List<RouteGuard> _guards;

  String? redirect(Uri location) {
    for (final guard in _guards) {
      final target = guard.redirect(location);
      if (target != null) {
        return target == location.path ? null : target;
      }
    }
    return null;
  }
}
