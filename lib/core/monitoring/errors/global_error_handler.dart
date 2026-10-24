import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart';
import 'package:hairextensions/core/monitoring/crash/non_fatal.dart';
import 'package:hairextensions/core/monitoring/errors/app_error_fallback.dart';
import 'package:injectable/injectable.dart';

/// Installed before runApp. Framework errors are non-fatal because the UI
/// keeps running behind the fallback widget; uncaught async errors are fatal.
@lazySingleton
class GlobalErrorHandler {
  GlobalErrorHandler(this._crashReporter);

  final CrashReporter _crashReporter;

  void install() {
    NonFatal.reporter = _crashReporter;
    FlutterError.onError = (details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
      unawaited(_crashReporter.recordFlutterError(details));
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      unawaited(_crashReporter.recordError(error, stackTrace, fatal: true));
      return true;
    };
    if (!kDebugMode) {
      ErrorWidget.builder = (_) => const AppErrorFallback();
    }
  }
}
