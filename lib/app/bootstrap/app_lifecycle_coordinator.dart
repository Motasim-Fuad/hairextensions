import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/monitoring/monitoring_initializer.dart';
import 'package:injectable/injectable.dart';

/// Foreground work only. Nothing runs while the app is in the background.
@lazySingleton
class AppLifecycleCoordinator {
  AppLifecycleCoordinator(this._monitoring);

  final MonitoringInitializer _monitoring;
  AppLifecycleListener? _listener;

  void start() {
    _listener ??= AppLifecycleListener(onResume: () => unawaited(_monitoring.onResume()));
  }

  @disposeMethod
  void dispose() {
    _listener?.dispose();
    _listener = null;
  }
}
