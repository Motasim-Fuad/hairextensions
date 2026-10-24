import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OnboardingGuard implements RouteGuard {
  OnboardingGuard(this._session);

  final AppSession _session;

  @override
  String? redirect(Uri location) {
    final onOnboarding = RouteAccess.matches(location.path, AppRoutes.onboardingPath);
    if (!_session.onboardingSeen) {
      return AppRoutes.onboardingPath;
    }
    return onOnboarding ? AppRoutes.homePath : null;
  }
}
