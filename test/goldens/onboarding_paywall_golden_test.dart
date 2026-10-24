@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_theme.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/pages/paywall_page.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fakes/fake_app_session.dart';
import '../helpers/fakes/fake_subscription_service.dart';
import '../helpers/load_app_fonts.dart';

class _MockLinkLauncher extends Mock implements LinkLauncher {}

/// Screens at the Figma frame size (393 x 852) for side-by-side review.
void main() {
  const frame = Size(393, 852);
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  setUpAll(loadAppFonts);

  setUp(() {
    getIt
      ..registerFactory<OnboardingCubit>(() => OnboardingCubit(FakeAppSession()))
      ..registerFactory<PaywallCubit>(
        () => PaywallCubit(FakeSubscriptionService(), AppConfig.fromEnvironment(), _MockLinkLauncher()),
      );
  });

  tearDown(getIt.reset);

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view
      ..physicalSize = frame
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: AppLocales.delegates,
        supportedLocales: AppLocales.supported,
        home: screen,
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
  }

  testWidgets('splash and onboarding pages', (tester) async {
    await pumpScreen(tester, const OnboardingPage());
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screens/1_1_splash.png'));

    await tester.pump(AppMotion.splashHold);
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screens/1_2_onboarding_1.png'));

    await tester.tap(find.text(l10n.actionNext));
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screens/1_3_onboarding_2.png'));

    await tester.tap(find.text(l10n.actionNext));
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screens/1_4_onboarding_3.png'));
  });

  testWidgets('paywall', (tester) async {
    await pumpScreen(tester, const PaywallPage());
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screens/1_5_paywall.png'));
  });
}
