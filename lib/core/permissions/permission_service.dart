import 'package:hairextensions/core/permissions/app_permission.dart';
import 'package:hairextensions/core/permissions/app_permission_status.dart';

abstract interface class PermissionService {
  Future<AppPermissionStatus> status(AppPermission permission);

  /// Requests only when the system can still show a prompt; returns the
  /// permanently denied status without prompting otherwise.
  Future<AppPermissionStatus> request(AppPermission permission);

  Future<bool> openSettings();
}
