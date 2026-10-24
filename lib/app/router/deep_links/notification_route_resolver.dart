import 'package:hairextensions/core/routing/app_routes.dart';

/// Turns a push notification payload such as `{"route": "quotes"}` into an
/// in-app location. Only allow-listed route names are accepted, so a payload
/// can never open an arbitrary path. Guards still apply after navigation.
abstract final class NotificationRouteResolver {
  static const String routeKey = 'route';

  static const Map<String, String> _locations = {
    AppRoutes.home: AppRoutes.homePath,
    AppRoutes.quotes: AppRoutes.quotesPath,
    AppRoutes.library: AppRoutes.libraryPath,
    AppRoutes.settings: AppRoutes.settingsPath,
    AppRoutes.newQuote: AppRoutes.newQuotePath,
    AppRoutes.paywall: AppRoutes.paywallPath,
  };

  static String? locationFor(Map<String, Object?> data) {
    final route = data[routeKey];
    return route is String ? _locations[route] : null;
  }
}
