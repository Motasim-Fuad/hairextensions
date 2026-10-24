import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/permissions/app_permission.dart';
import 'package:hairextensions/core/permissions/app_permission_status.dart';
import 'package:hairextensions/core/permissions/permission_service.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton(as: PermissionService)
class PermissionHandlerService implements PermissionService {
  static const String _source = 'PermissionService';

  @override
  Future<AppPermissionStatus> status(AppPermission permission) async {
    return _map(await _permissionOf(permission).status);
  }

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final current = _map(await _permissionOf(permission).status);
    if (current.isUsable || current.needsSettings) {
      return current;
    }
    final result = _map(await _permissionOf(permission).request());
    AppLogger.debug(_source, '${permission.name} ${result.name}');
    return result;
  }

  @override
  Future<bool> openSettings() => openAppSettings();

  Permission _permissionOf(AppPermission permission) {
    return switch (permission) {
      AppPermission.location => Permission.locationWhenInUse,
      AppPermission.notification => Permission.notification,
      AppPermission.camera => Permission.camera,
      AppPermission.photos => Permission.photos,
    };
  }

  AppPermissionStatus _map(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted || PermissionStatus.provisional => AppPermissionStatus.granted,
      PermissionStatus.limited => AppPermissionStatus.limited,
      PermissionStatus.denied => AppPermissionStatus.denied,
      PermissionStatus.permanentlyDenied => AppPermissionStatus.permanentlyDenied,
      PermissionStatus.restricted => AppPermissionStatus.restricted,
    };
  }
}
