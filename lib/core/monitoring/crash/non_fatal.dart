import 'dart:async';

import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart';

/// Non-fatal reporting for code paths without DI access, such as top-level
/// helpers. The reporter is assigned once during bootstrap.
abstract final class NonFatal {
  static CrashReporter? reporter;

  static void record(Object error, StackTrace stackTrace, {String? reason}) {
    final pending = reporter?.recordError(error, stackTrace, reason: reason);
    if (pending != null) {
      unawaited(pending);
    }
  }
}
