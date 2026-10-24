import 'dart:async';

import 'package:hairextensions/app/bootstrap/app_feature_modules.dart';
import 'package:hairextensions/app/bootstrap/app_lifecycle_coordinator.dart';
import 'package:hairextensions/app/bootstrap/device_session_starter.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/feature_flags/feature_module_registry.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/crash/non_fatal.dart';
import 'package:hairextensions/core/monitoring/monitoring_initializer.dart';
import 'package:injectable/injectable.dart';

/// Everything that is not needed to paint the first screen. Runs once after
/// the first frame; each step is isolated so one failure cannot stop others.
@lazySingleton
class DeferredInitializer {
  DeferredInitializer(this._modules, this._monitoring, this._connectivity, this._session, this._lifecycle);

  static const String _source = 'DeferredInitializer';

  final FeatureModuleRegistry _modules;
  final MonitoringInitializer _monitoring;
  final ConnectivityCubit _connectivity;
  final DeviceSessionStarter _session;
  final AppLifecycleCoordinator _lifecycle;
  bool _started = false;

  void run() {
    if (_started) {
      return;
    }
    _started = true;
    _modules.registerAll(AppFeatureModules.foreground());
    _lifecycle.start();
    _guard('connectivity', _connectivity.start);
    _guard('monitoring', _monitoring.initialize);
    _guard('session', _session.start);
  }

  void _guard(String step, Future<void> Function() action) {
    unawaited(
      action().catchError((Object error, StackTrace stackTrace) {
        AppLogger.error(_source, '$step failed', error);
        NonFatal.record(error, stackTrace, reason: step);
      }),
    );
  }
}
