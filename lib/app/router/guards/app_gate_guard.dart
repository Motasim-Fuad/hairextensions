import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:injectable/injectable.dart';

/// Maintenance and required updates override every other rule.
@lazySingleton
class AppGateGuard implements RouteGuard {
  AppGateGuard(this._gate);

  final AppGateService _gate;

  @override
  String? redirect(Uri location) {
    final path = location.path;
    final target = switch (_gate.status) {
      AppGateStatus.maintenance => AppRoutes.maintenancePath,
      AppGateStatus.updateRequired => AppRoutes.forceUpdatePath,
      AppGateStatus.ok || AppGateStatus.updateRecommended => null,
    };
    if (target != null) {
      return target;
    }
    return RouteAccess.matchesAny(path, RouteAccess.blockingPaths) ? AppRoutes.homePath : null;
  }
}
