import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/feature_flags/app_status_config.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';

abstract final class AppGateEvaluator {
  static AppGateStatus evaluate({required AppStatusConfig config, required AppVersion current}) {
    if (config.maintenanceEnabled) {
      return AppGateStatus.maintenance;
    }
    if (current < config.minSupportedVersion) {
      return AppGateStatus.updateRequired;
    }
    if (current < config.latestVersion) {
      return AppGateStatus.updateRecommended;
    }
    return AppGateStatus.ok;
  }
}
