import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/feature_flags/app_gate_evaluator.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/feature_flags/app_status_config.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Force update and maintenance state for the router. Stays [AppGateStatus.ok]
/// until [initialize] has read the installed version.
@lazySingleton
class AppGateService extends ChangeNotifier {
  AppGateService(this._flags) {
    _flags.addListener(_reevaluate);
  }

  final FeatureFlagService _flags;
  AppVersion? _installed;
  AppGateStatus _status = AppGateStatus.ok;

  AppGateStatus get status => _status;

  AppStatusConfig get config => _flags.appStatus;

  String? get installedVersion => _installed?.toString();

  Future<void> initialize() async {
    if (_installed != null) {
      return;
    }
    final info = await PackageInfo.fromPlatform();
    _installed = AppVersion.tryParse(info.version) ?? AppVersion.zero;
    _reevaluate();
  }

  void _reevaluate() {
    final installed = _installed;
    if (installed == null) {
      return;
    }
    final next = AppGateEvaluator.evaluate(config: _flags.appStatus, current: installed);
    if (next != _status) {
      _status = next;
      notifyListeners();
    }
  }

  @override
  @disposeMethod
  void dispose() {
    _flags.removeListener(_reevaluate);
    super.dispose();
  }
}
