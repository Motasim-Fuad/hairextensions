import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/app/gate/force_update_page.dart';
import 'package:hairextensions/app/gate/maintenance_page.dart';
import 'package:hairextensions/app/router/guards/route_guard_chain.dart';
import 'package:hairextensions/app/router/transitions/fade_slide_page.dart';
import 'package:hairextensions/app/router/transitions/slide_up_page.dart';
import 'package:hairextensions/app/shell/app_shell.dart';
import 'package:hairextensions/app/shell/shell_tab.dart';
import 'package:hairextensions/core/analytics/analytics_route_observer.dart';
import 'package:hairextensions/core/analytics/screen_view_tracker.dart';
import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/features/business_setup/presentation/routes/business_setup_routes.dart';
import 'package:hairextensions/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:hairextensions/features/auth/presentation/pages/login/login_page.dart';
import 'package:hairextensions/features/auth/presentation/pages/register/register_page.dart';
import 'package:hairextensions/features/library/presentation/pages/library/library_page.dart';
import 'package:hairextensions/features/library/presentation/pages/product_form/product_form_page.dart';
import 'package:hairextensions/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:hairextensions/features/paywall/presentation/pages/paywall_page.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/pages/builder/quote_builder_page.dart';
import 'package:hairextensions/features/quotes/presentation/pages/detail/quote_detail_page.dart';
import 'package:hairextensions/features/quotes/presentation/pages/history/quote_history_page.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/home_page.dart';
import 'package:hairextensions/features/quotes/presentation/pages/preview/quote_preview_page.dart';
import 'package:hairextensions/features/quotes/presentation/pages/review/quote_review_page.dart';
import 'package:hairextensions/features/settings/presentation/pages/settings_page.dart';
import 'package:hairextensions/shared/widgets/feedback/app_error_screen.dart';
import 'package:injectable/injectable.dart';

/// The only GoRouter. Features contribute route lists; guards, transitions
/// and the tab shell are decided here.
///
/// Session flags are deliberately not a refresh source: they flip right
/// before an explicit navigation, and a refresh at that moment would bounce
/// the current page through the guards first.
@lazySingleton
class AppRouter {
  AppRouter(
    this._guards,
    this._gate,
    this._flags,
    this._subscription,
    this._screenViews,
    this._launcher,
  );

  final RouteGuardChain _guards;
  final AppGateService _gate;
  final FeatureFlagService _flags;
  final SubscriptionService _subscription;
  final ScreenViewTracker _screenViews;
  final LinkLauncher _launcher;
  final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  late final GoRouter config = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.homePath,
    refreshListenable: Listenable.merge([_gate, _flags, _subscription]),
    redirect: (_, state) => _guards.redirect(state.uri),
    observers: [AnalyticsRouteObserver(_screenViews)],
    errorBuilder: (context, _) => AppErrorScreen(onGoHome: () => context.go(AppRoutes.homePath)),
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.homePath),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboarding,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordPath,
        name: AppRoutes.forgotPassword,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.paywallPath,
        name: AppRoutes.paywall,
        pageBuilder: (_, state) => SlideUpPage<void>(
          state: state,
          child: const PaywallPage(),
        ),
      ),
      ...BusinessSetupRoutes.firstLaunch,
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell, screenViews: _screenViews),
        branches: [
          _branch(_tabRoute(ShellTab.home, AppRoutes.homePath, const HomePage())),
          _branch(_tabRoute(ShellTab.quotes, AppRoutes.quotesPath, const QuoteHistoryPage())),
          _branch(_tabRoute(ShellTab.library, AppRoutes.libraryPath, const LibraryPage())),
          _branch(
            GoRoute(
              path: AppRoutes.settingsPath,
              name: AppRoutes.settings,
              builder: (_, _) => const SettingsPage(),
              routes: BusinessSetupRoutes.settingsEditors(_rootKey),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.newQuotePath,
        name: AppRoutes.newQuote,
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, state) => SlideUpPage<void>(
          state: state,
          child: QuoteBuilderPage(template: state.extra is Quote ? state.extra! as Quote : null),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.quoteReviewPath,
            name: AppRoutes.quoteReview,
            parentNavigatorKey: _rootKey,
            redirect: (_, state) => state.extra is Quote ? null : AppRoutes.newQuotePath,
            pageBuilder: (_, state) => FadeSlidePage<void>(
              state: state,
              child: QuoteReviewPage(quote: state.extra! as Quote),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.quoteDetailPath,
        name: AppRoutes.quoteDetail,
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: QuoteDetailPage(quoteId: state.pathParameters[AppRoutes.idParam]!),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.quotePreviewPath,
            name: AppRoutes.quotePreview,
            parentNavigatorKey: _rootKey,
            pageBuilder: (_, state) => FadeSlidePage<void>(
              state: state,
              child: QuotePreviewPage(quoteId: state.pathParameters[AppRoutes.idParam]!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productFormPath,
        name: AppRoutes.productForm,
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, state) => SlideUpPage<void>(
          state: state,
          child: ProductFormPage(product: state.extra is Product ? state.extra! as Product : null),
        ),
      ),
      GoRoute(
        path: AppRoutes.maintenancePath,
        name: AppRoutes.maintenance,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: MaintenancePage(flags: _flags),
        ),
      ),
      GoRoute(
        path: AppRoutes.forceUpdatePath,
        name: AppRoutes.forceUpdate,
        pageBuilder: (_, state) => FadeSlidePage<void>(
          state: state,
          child: ForceUpdatePage(gate: _gate, launcher: _launcher),
        ),
      ),
    ],
  );

  /// Each tab navigator gets its own observer; an observer can only be
  /// attached to one navigator.
  StatefulShellBranch _branch(GoRoute route) {
    return StatefulShellBranch(observers: [AnalyticsRouteObserver(_screenViews)], routes: [route]);
  }

  GoRoute _tabRoute(ShellTab tab, String path, Widget page) {
    return GoRoute(path: path, name: tab.routeName, builder: (_, _) => page);
  }
}
