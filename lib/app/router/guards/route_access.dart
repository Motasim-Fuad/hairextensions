import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';

/// Which paths need Pro or a feature flag. Matching is by path prefix, so
/// nested routes inherit the rule of their parent.
abstract final class RouteAccess {
  static const List<String> authPaths = [
    AppRoutes.loginPath,
    AppRoutes.registerPath,
    AppRoutes.forgotPasswordPath,
  ];

  static const List<String> firstLaunchPaths = [
    AppRoutes.setupPath,
    AppRoutes.paywallPath,
    ...authPaths,
  ];

  static const List<String> blockingPaths = [AppRoutes.maintenancePath, AppRoutes.forceUpdatePath];

  static const List<String> proOnlyPaths = [AppRoutes.newQuotePath];

  static const Map<String, FeatureKey> featureGatedPaths = {
    AppRoutes.newQuotePath: FeatureKey.quoteBuilder,
    AppRoutes.libraryPath: FeatureKey.library,
    AppRoutes.paywallPath: FeatureKey.subscriptions,
  };

  static bool matches(String path, String prefix) => path == prefix || path.startsWith('$prefix/');

  static bool matchesAny(String path, Iterable<String> prefixes) => prefixes.any((prefix) => matches(path, prefix));
}
