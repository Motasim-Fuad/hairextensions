import 'package:flutter/foundation.dart';

/// The only debug output channel in the app. Silent outside debug mode.
abstract final class AppLogger {
  static final RegExp _whitespace = RegExp(r'\s+');

  static void debug(String source, String message) {
    _write(source, message);
  }

  static void warning(String source, String message) {
    _write(source, 'warning $message');
  }

  static void error(String source, String message, [Object? error]) {
    final detail = error == null ? message : '$message $error';
    _write(source, 'error $detail');
  }

  static void _write(String source, String message) {
    if (!kDebugMode) {
      return;
    }
    final singleLine = message.replaceAll(_whitespace, ' ').trim();
    debugPrint('$source: $singleLine');
  }
}
