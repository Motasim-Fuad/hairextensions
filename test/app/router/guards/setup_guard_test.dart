import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/guards/onboarding_guard.dart';
import 'package:hairextensions/app/router/guards/setup_guard.dart';
import 'package:hairextensions/core/routing/app_routes.dart';

import '../../../helpers/fakes/fake_app_session.dart';

void main() {
  group('OnboardingGuard', () {
    test('forces onboarding until it has been seen', () {
      final guard = OnboardingGuard(FakeAppSession());
      expect(guard.redirect(Uri.parse(AppRoutes.homePath)), AppRoutes.onboardingPath);
      expect(guard.redirect(Uri.parse(AppRoutes.onboardingPath)), AppRoutes.onboardingPath);
    });

    test('never shows onboarding again once seen', () {
      final guard = OnboardingGuard(FakeAppSession(onboardingSeen: true));
      expect(guard.redirect(Uri.parse(AppRoutes.onboardingPath)), AppRoutes.homePath);
      expect(guard.redirect(Uri.parse(AppRoutes.quotesPath)), isNull);
    });
  });

  group('SetupGuard', () {
    test('only the wizard and paywall are reachable before setup', () {
      final guard = SetupGuard(FakeAppSession(onboardingSeen: true));
      expect(guard.redirect(Uri.parse(AppRoutes.setupPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.paywallPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.homePath)), AppRoutes.setupPath);
      expect(guard.redirect(Uri.parse(AppRoutes.newQuotePath)), AppRoutes.setupPath);
      expect(guard.redirect(Uri.parse(AppRoutes.setupCompletePath)), AppRoutes.setupPath);
    });

    test('the account screens are reachable before setup', () {
      final guard = SetupGuard(FakeAppSession(onboardingSeen: true));
      expect(guard.redirect(Uri.parse(AppRoutes.loginPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.registerPath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.forgotPasswordPath)), isNull);
    });

    test('after setup the wizard is closed but the all-set screen is open', () {
      final guard = SetupGuard(FakeAppSession(onboardingSeen: true, setupCompleted: true));
      expect(guard.redirect(Uri.parse(AppRoutes.setupPath)), AppRoutes.homePath);
      expect(guard.redirect(Uri.parse(AppRoutes.setupCompletePath)), isNull);
      expect(guard.redirect(Uri.parse(AppRoutes.paywallPath)), isNull);
      expect(guard.redirect(Uri.parse('${AppRoutes.settingsPath}/${AppRoutes.editBusinessProfilePath}')), isNull);
    });
  });
}
