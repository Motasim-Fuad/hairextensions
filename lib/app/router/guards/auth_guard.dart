import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:injectable/injectable.dart';

/// Everything except the login, register and OTP screens needs a signed-in
/// account. Signed-in users never see the auth screens.
@lazySingleton
class AuthGuard implements RouteGuard {
  AuthGuard(this._session);

  final AppSession _session;

  @override
  String? redirect(Uri location) {
    final path = location.path;
    if (RouteAccess.matchesAny(path, RouteAccess.blockingPaths)) {
      return null;
    }
    final onAuthScreen = RouteAccess.matchesAny(path, RouteAccess.authPaths);
    if (!_session.signedIn) {
      return onAuthScreen ? null : AppRoutes.loginPath;
    }
    return onAuthScreen ? AppRoutes.homePath : null;
  }
}
