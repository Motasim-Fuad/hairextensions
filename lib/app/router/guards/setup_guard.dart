import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:injectable/injectable.dart';

/// Until setup is finished only the wizard and the paywall are reachable.
/// The all-set screen sits under the setup path but needs a finished setup.
@lazySingleton
class SetupGuard implements RouteGuard {
  SetupGuard(this._session);

  final AppSession _session;

  @override
  String? redirect(Uri location) {
    final path = location.path;
    final onComplete = RouteAccess.matches(path, AppRoutes.setupCompletePath);
    if (!_session.setupCompleted) {
      final allowed = !onComplete && RouteAccess.matchesAny(path, RouteAccess.firstLaunchPaths);
      return allowed ? null : AppRoutes.setupPath;
    }
    final onWizard = !onComplete && RouteAccess.matches(path, AppRoutes.setupPath);
    return onWizard ? AppRoutes.homePath : null;
  }
}
