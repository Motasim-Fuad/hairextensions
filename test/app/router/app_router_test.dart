import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/app_router.dart';
import 'package:hairextensions/app/router/guards/app_gate_guard.dart';
import 'package:hairextensions/app/router/guards/auth_guard.dart';
import 'package:hairextensions/app/router/guards/feature_flag_guard.dart';
import 'package:hairextensions/app/router/guards/onboarding_guard.dart';
import 'package:hairextensions/app/router/guards/route_guard_chain.dart';
import 'package:hairextensions/app/router/guards/setup_guard.dart';
import 'package:hairextensions/app/router/guards/subscription_guard.dart';
import 'package:hairextensions/core/analytics/screen_view_tracker.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/connectivity/connectivity_status.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_scope.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/session/session_refresh.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/theme/app_theme.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/library/data/repositories/demo_library_repository.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_cubit.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/quotes/data/repositories/demo_quote_repository.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_history_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/home/home_cubit.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes/fake_app_session.dart';
import '../../helpers/fakes/fake_subscription_service.dart';
import '../../helpers/fakes/session_account_gateway.dart';
import '../../helpers/mocks/mock_analytics_service.dart';
import '../../helpers/mocks/mock_app_gate_service.dart';
import '../../helpers/mocks/mock_connectivity_cubit.dart';
import '../../helpers/test_feature_flags.dart';

class _MockLinkLauncher extends Mock implements LinkLauncher {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _EmptyProfileReader implements BusinessProfileReader {
  @override
  Future<BusinessProfile?> read() async => null;

  @override
  Stream<BusinessProfile?> watch() => Stream.value(null);
}

void main() {
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  late MockAppGateService gate;
  late MockAnalyticsService analytics;
  late MockConnectivityCubit connectivity;
  late FakeAppSession session;
  late _MockAuthRepository mockAuthRepository;

  setUp(() {
    gate = MockAppGateService();

    when(() => gate.status).thenReturn(AppGateStatus.ok);

    analytics = MockAnalyticsService();

    when(() => analytics.logScreenView(any()))
        .thenAnswer((_) async {});

    connectivity = MockConnectivityCubit();

    when(() => connectivity.state)
        .thenReturn(ConnectivityStatus.online);

    when(() => connectivity.stream)
        .thenAnswer((_) => const Stream.empty());

    session = FakeAppSession();

    mockAuthRepository = _MockAuthRepository();

    when(() => mockAuthRepository.endSession())
        .thenAnswer((_) async {});
  });

  Future<void> pumpRouter(
      WidgetTester tester, {
        Map<FeatureKey, bool> flags = const {},
      }) async {
    final features = TestFeatureFlags.build(overrides: flags);
    final subscription = FakeSubscriptionService();
    final clock = Clock();
    final quotes = DemoQuoteRepository(clock);
    final library = DemoLibraryRepository(clock);
    final profiles = _EmptyProfileReader();

    final router = AppRouter(
      RouteGuardChain(
        AppGateGuard(gate),
        OnboardingGuard(session),
        AuthGuard(session),
        SetupGuard(session),
        FeatureFlagGuard(features),
        SubscriptionGuard(subscription, features),
      ),
      gate,
      features,
      subscription,
      ScreenViewTracker(analytics),
      _MockLinkLauncher(),
      SessionRefresh(),
    );

    getIt
      ..registerSingleton<AccountGateway>(SessionAccountGateway(session))
      ..registerFactory<OnboardingCubit>(
            () => OnboardingCubit(session),
      )
      ..registerFactory<PaywallCubit>(
            () => PaywallCubit(
          subscription,
          AppConfig.fromEnvironment(),
          _MockLinkLauncher(),
        ),
      )
      ..registerFactory<HomeCubit>(
            () => HomeCubit(quotes, profiles, clock),
      )
      ..registerFactory<QuoteHistoryCubit>(
            () => QuoteHistoryCubit(quotes, clock),
      )
      ..registerFactory<LibraryCubit>(
            () => LibraryCubit(library),
      )
      ..registerFactory<SettingsCubit>(
            () => SettingsCubit(
          profiles,
          library,
          subscription,
          AppConfig.fromEnvironment(),
          _MockLinkLauncher(),
          mockAuthRepository,
          gate,
        ),
      );

    addTearDown(getIt.reset);

    await tester.pumpWidget(
      FeatureFlagScope(
        service: features,
        child: BlocProvider<ConnectivityCubit>.value(
          value: connectivity,
          child: MaterialApp.router(
            routerConfig: router.config,
            theme: AppTheme.light(),
            localizationsDelegates: AppLocales.delegates,
            supportedLocales: AppLocales.supported,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> openLogin(WidgetTester tester) async {
    await pumpRouter(tester);
    await tester.pump(AppMotion.splashHold);
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.actionSkip));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'first launch opens onboarding, and skipping opens log in',
        (tester) async {
      await pumpRouter(tester);

      await tester.pump(AppMotion.splashHold);
      await tester.pumpAndSettle();

      expect(find.text(l10n.onboardingCostTitle), findsOneWidget);

      await tester.tap(find.text(l10n.actionSkip));
      await tester.pumpAndSettle();

      expect(session.onboardingSeen, isTrue);
      expect(find.text(l10n.authLoginTitle), findsOneWidget);
    },
  );

  testWidgets(
    'logging in continues to the paywall',
        (tester) async {
      await openLogin(tester);

      expect(find.text(l10n.authLoginTitle), findsOneWidget);

      final fields = find.byType(TextField);

      await tester.enterText(
        fields.at(0),
        'amna@example.com',
      );

      await tester.enterText(
        fields.at(1),
        'secret123',
      );

      await tester.tap(find.text(l10n.authActionLogin));

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text(l10n.paywallTitle), findsOneWidget);
    },
  );

  testWidgets(
    'log in and registration link to each other',
        (tester) async {
      await openLogin(tester);

      await tester.tap(find.text(l10n.authActionRegister));
      await tester.pumpAndSettle();

      expect(find.text(l10n.authRegisterTitle), findsOneWidget);

      await tester.tap(find.text(l10n.authActionLogin));
      await tester.pumpAndSettle();

      expect(find.text(l10n.authLoginTitle), findsOneWidget);
    },
  );

  testWidgets(
    'forgot password opens from log in and returns',
        (tester) async {
      await openLogin(tester);

      await tester.tap(find.text(l10n.authForgotPasswordLink));
      await tester.pumpAndSettle();

      expect(find.text(l10n.authForgotTitle), findsOneWidget);

      await tester.enterText(
        find.byType(TextField),
        'amna@example.com',
      );

      await tester.tap(find.text(l10n.authActionSendLink));

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text(l10n.authForgotSentTitle), findsOneWidget);

      await tester.tap(find.text(l10n.authActionBackToLogin));
      await tester.pumpAndSettle();

      expect(find.text(l10n.authLoginTitle), findsOneWidget);
    },
  );

  testWidgets(
    'a finished setup opens the tab shell and keeps tabs switchable',
        (tester) async {
      session
        ..onboardingSeen = true
        ..setupCompleted = true
        ..signedIn = true;

      await pumpRouter(tester);

      expect(find.text(l10n.navLibrary), findsOneWidget);

      await tester.tap(find.text(l10n.navQuotes).last);
      await tester.pumpAndSettle();

      expect(find.text(l10n.quotesSearchHint), findsOneWidget);

      verify(() => analytics.logScreenView('quotes')).called(1);
    },
  );

  testWidgets(
    'a tab whose feature is off is hidden',
        (tester) async {
      session
        ..onboardingSeen = true
        ..setupCompleted = true
        ..signedIn = true;

      await pumpRouter(
        tester,
        flags: {FeatureKey.library: false},
      );

      expect(find.text(l10n.navLibrary), findsNothing);
      expect(find.text(l10n.navSettings), findsOneWidget);
    },
  );
}