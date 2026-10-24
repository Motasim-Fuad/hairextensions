import 'package:flutter/foundation.dart';

abstract interface class CrashReporter {
  /// Enabling flushes errors captured before Firebase was ready; disabling
  /// discards them.
  Future<void> setCollectionEnabled({required bool enabled});

  Future<void> recordError(Object error, StackTrace? stackTrace, {bool fatal = false, String? reason});

  Future<void> recordFlutterError(FlutterErrorDetails details, {bool fatal = false});

  Future<void> log(String message);

  Future<void> setUserId(String id);

  Future<void> setCustomKey(String key, Object value);
}
