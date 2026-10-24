import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/guards/feature_flag_guard.dart';
import 'package:hairextensions/app/router/guards/subscription_guard.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';

import '../../../helpers/fakes/fake_subscription_service.dart';
import '../../../helpers/test_feature_flags.dart';

void main() {
  group('FeatureFlagGuard', () {
    test('a disabled feature route is unreachable', () {
      final guard = FeatureFlagGuard(TestFeatureFlags.build(overrides: {FeatureKey.library: false}));
      expect(guard.redirect(Uri.parse(AppRoutes.libraryPath)), AppRoutes.homePath);
      expect(guard.redirect(Uri.parse('${AppRoutes.libraryPath}/products')), AppRoutes.homePath);
      expect(guard.redirect(Uri.parse(AppRoutes.quotesPath)), isNull);
    });

    test('enabled features pass through', () {
      final guard = FeatureFlagGuard(TestFeatureFlags.build());
      expect(guard.redirect(Uri.parse(AppRoutes.libraryPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), isNull);
    });

    test('prefix matching does not catch similarly named paths', () {
      final guard = FeatureFlagGuard(TestFeatureFlags.build(overrides: {FeatureKey.library: false}));
      expect(guard.redirect(Uri.parse('${AppRoutes.libraryPath}-archive')), isNull);
    });
  });

  group('SubscriptionGuard', () {
    test('free users are sent from pro routes to the paywall', () {
      final guard = SubscriptionGuard(FakeSubscriptionService(), TestFeatureFlags.build());
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), AppRoutes.paywallPath);
      expect(guard.redirect(Uri.parse(AppRoutes.quotesPath)), isNull);
    });

    test('an expired plan keeps history but not creation', () {
      final guard = SubscriptionGuard(
        FakeSubscriptionService(SubscriptionStatus.expired),
        TestFeatureFlags.build(),
      );
      expect(guard.redirect(Uri.parse(AppRoutes.quotesPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), AppRoutes.paywallPath);
    });

    test('pro users skip the paywall', () {
      final guard = SubscriptionGuard(
        FakeSubscriptionService(SubscriptionStatus.active),
        TestFeatureFlags.build(),
      );
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.paywallPath)), AppRoutes.homePath);
    });

    test('switching subscriptions off remotely makes everything free', () {
      final guard = SubscriptionGuard(
        FakeSubscriptionService(),
        TestFeatureFlags.build(overrides: {FeatureKey.subscriptions: false}),
      );
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), isNull);
    });
  });
}
