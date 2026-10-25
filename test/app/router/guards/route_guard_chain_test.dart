import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/guards/app_gate_guard.dart';
import 'package:hairextensions/app/router/guards/auth_guard.dart';
import 'package:hairextensions/app/router/guards/feature_flag_guard.dart';
import 'package:hairextensions/app/router/guards/onboarding_guard.dart';
import 'package:hairextensions/app/router/guards/route_guard_chain.dart';
import 'package:hairextensions/app/router/guards/setup_guard.dart';
import 'package:hairextensions/app/router/guards/subscription_guard.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes/fake_app_session.dart';
import '../../../helpers/fakes/fake_subscription_service.dart';
import '../../../helpers/mocks/mock_app_gate_service.dart';
import '../../../helpers/test_feature_flags.dart';

/// Replays go_router's behaviour of re-running redirects on each new
/// location, so these tests check where the user finally lands.
void main() {
  const redirectLimit = 5;

  late MockAppGateService gate;
  late FakeAppSession session;
  late FakeSubscriptionService subscription;

  setUp(() {
    gate = MockAppGateService();
    when(() => gate.status).thenReturn(AppGateStatus.ok);
    session = FakeAppSession(signedIn: true);
    subscription = FakeSubscriptionService();
  });

  String land(String path, {Map<FeatureKey, bool> flags = const {}}) {
    final features = TestFeatureFlags.build(overrides: flags);
    final chain = RouteGuardChain(
      AppGateGuard(gate),
      OnboardingGuard(session),
      AuthGuard(session),
      SetupGuard(session),
      FeatureFlagGuard(features),
      SubscriptionGuard(subscription, features),
    );
    var location = path;
    for (var hop = 0; hop < redirectLimit; hop++) {
      final next = chain.redirect(Uri.parse(location));
      if (next == null) {
        return location;
      }
      location = next;
    }
    fail('redirect loop from $path');
  }

  test('a fresh install always starts at onboarding', () {
    expect(land(AppRoutes.homePath), AppRoutes.onboardingPath);
    expect(land(AppRoutes.newQuotePath), AppRoutes.onboardingPath);
  });

  test('after onboarding the paywall is shown, then setup', () {
    session.onboardingSeen = true;
    expect(land(AppRoutes.paywallPath), AppRoutes.paywallPath);
    expect(land(AppRoutes.homePath), AppRoutes.setupPath);
  });

  test('with subscriptions off the paywall is skipped straight to setup', () {
    session.onboardingSeen = true;
    expect(land(AppRoutes.paywallPath, flags: {FeatureKey.subscriptions: false}), AppRoutes.setupPath);
  });

  test('a finished free user lands on tabs and hits the paywall for pro routes', () {
    session
      ..onboardingSeen = true
      ..setupCompleted = true;
    expect(land(AppRoutes.homePath), AppRoutes.homePath);
    expect(land(AppRoutes.setupPath), AppRoutes.homePath);
    expect(land(AppRoutes.onboardingPath), AppRoutes.homePath);
    expect(land(AppRoutes.newQuotePath), AppRoutes.paywallPath);
  });

  test('a pro user opens the quote builder directly', () {
    session
      ..onboardingSeen = true
      ..setupCompleted = true;
    subscription.status = SubscriptionStatus.active;
    expect(land(AppRoutes.newQuotePath), AppRoutes.newQuotePath);
  });

  test('a signed-out user is sent to log in from every protected route', () {
    session
      ..onboardingSeen = true
      ..signedIn = false;
    expect(land(AppRoutes.homePath), AppRoutes.loginPath);
    expect(land(AppRoutes.newQuotePath), AppRoutes.loginPath);
    expect(land(AppRoutes.loginPath), AppRoutes.loginPath);
    expect(land(AppRoutes.registerPath), AppRoutes.registerPath);
    expect(land(AppRoutes.verifyOtpPath), AppRoutes.verifyOtpPath);
  });

  test('a signed-in user never sees the log in screens', () {
    session
      ..onboardingSeen = true
      ..setupCompleted = true;
    expect(land(AppRoutes.loginPath), AppRoutes.homePath);
    expect(land(AppRoutes.registerPath), AppRoutes.homePath);
  });

  test('maintenance wins over every other rule, even on first launch', () {
    when(() => gate.status).thenReturn(AppGateStatus.maintenance);
    expect(land(AppRoutes.onboardingPath), AppRoutes.maintenancePath);
  });

  test('leaving maintenance resumes the normal flow', () {
    session.onboardingSeen = true;
    expect(land(AppRoutes.maintenancePath), AppRoutes.setupPath);
  });
}
