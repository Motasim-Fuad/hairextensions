import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart';
import 'package:hairextensions/core/monitoring/crash/pending_crash_record.dart';
import 'package:injectable/injectable.dart';

/// Disabled in debug builds (errors are logged instead). Errors raised before
/// Firebase starts are buffered and sent once collection is enabled.
@LazySingleton(as: CrashReporter)
class FirebaseCrashReporter implements CrashReporter {
  FirebaseCrashReporter(this._firebase);

  static const String _source = 'CrashReporter';
  static const int _maxPending = 20;

  final FirebaseBootstrapper _firebase;
  final List<PendingCrashRecord> _pending = [];
  bool _enabled = false;

  bool get _canSend => _firebase.isReady && _enabled && !kDebugMode;

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {
    _enabled = enabled;
    if (!_firebase.isReady) {
      return;
    }
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled && !kDebugMode);
    if (!_canSend) {
      _pending.clear();
      return;
    }
    final queued = List.of(_pending);
    _pending.clear();
    for (final record in queued) {
      await _send(record);
    }
  }

  @override
  Future<void> recordError(Object error, StackTrace? stackTrace, {bool fatal = false, String? reason}) {
    return _submit(PendingCrashRecord(error: error, stackTrace: stackTrace, fatal: fatal, reason: reason));
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details, {bool fatal = false}) {
    return _submit(
      PendingCrashRecord(
        error: details.exception,
        stackTrace: details.stack,
        fatal: fatal,
        reason: details.context?.toDescription(),
      ),
    );
  }

  @override
  Future<void> log(String message) async {
    if (_canSend) {
      await FirebaseCrashlytics.instance.log(message);
    }
  }

  @override
  Future<void> setUserId(String id) async {
    if (_canSend) {
      await FirebaseCrashlytics.instance.setUserIdentifier(id);
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (_canSend) {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    }
  }

  Future<void> _submit(PendingCrashRecord record) async {
    if (kDebugMode) {
      AppLogger.error(_source, record.reason ?? 'error', record.error);
      return;
    }
    if (_canSend) {
      await _send(record);
      return;
    }
    if (!_firebase.isReady && _pending.length < _maxPending) {
      _pending.add(record);
    }
  }

  Future<void> _send(PendingCrashRecord record) {
    return FirebaseCrashlytics.instance.recordError(
      record.error,
      record.stackTrace,
      fatal: record.fatal,
      reason: record.reason,
    );
  }
}
