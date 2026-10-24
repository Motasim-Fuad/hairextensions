import 'package:hairextensions/app/router/guards/route_access.dart';
import 'package:hairextensions/app/router/guards/route_guard.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:injectable/injectable.dart';

/// A route whose flag is off is unreachable, including from deep links.
@lazySingleton
class FeatureFlagGuard implements RouteGuard {
  FeatureFlagGuard(this._flags);

  final FeatureFlagService _flags;

  @override
  String? redirect(Uri location) {
    for (final entry in RouteAccess.featureGatedPaths.entries) {
      if (RouteAccess.matches(location.path, entry.key) && !_flags.isEnabled(entry.value)) {
        return AppRoutes.homePath;
      }
    }
    return null;
  }
}
