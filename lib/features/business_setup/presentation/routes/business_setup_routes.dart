import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/business_setup_page.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/setup_complete_page.dart';

/// Consumed by the app router.
abstract final class BusinessSetupRoutes {
  static final List<GoRoute> firstLaunch = [
    GoRoute(
      path: AppRoutes.setupPath,
      name: AppRoutes.setup,
      builder: (_, _) => const BusinessSetupPage(flow: SetupFlow.onboarding),
    ),
    GoRoute(
      path: AppRoutes.setupCompletePath,
      name: AppRoutes.setupComplete,
      builder: (_, _) => const SetupCompletePage(),
    ),
  ];

  /// Nested under the settings route and pushed on [parentNavigatorKey], the
  /// root navigator, so the forms cover the bottom navigation.
  static List<GoRoute> settingsEditors(GlobalKey<NavigatorState> parentNavigatorKey) => [
    GoRoute(
      path: AppRoutes.editBusinessProfilePath,
      name: AppRoutes.editBusinessProfile,
      parentNavigatorKey: parentNavigatorKey,
      builder: (_, _) => const BusinessSetupPage(flow: SetupFlow.editProfile),
    ),
    GoRoute(
      path: AppRoutes.editQuoteDefaultsPath,
      name: AppRoutes.editQuoteDefaults,
      parentNavigatorKey: parentNavigatorKey,
      builder: (_, _) => const BusinessSetupPage(flow: SetupFlow.editQuoteDefaults),
    ),
  ];
}
