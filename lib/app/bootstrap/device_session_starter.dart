import 'dart:async';

import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/features/auth/domain/usecases/ensure_device_session.dart';
import 'package:injectable/injectable.dart';

/// Opens the silent device session after the first frame and opens a new one
/// whenever the server rejects the refresh token. Failures are retried on the
/// next start or expiry; the app works offline without a session.
@lazySingleton
class DeviceSessionStarter {
  DeviceSessionStarter(this._ensureSession, this._expiry);

  static const String _source = 'DeviceSessionStarter';

  final EnsureDeviceSession _ensureSession;
  final SessionExpiryNotifier _expiry;
  StreamSubscription<void>? _subscription;

  Future<void> start() async {
    _subscription ??= _expiry.onExpired.listen((_) => unawaited(_ensure()));
    await _ensure();
  }

  Future<void> _ensure() async {
    final result = await _ensureSession();
    result.match(
      (failure) => AppLogger.warning(_source, 'session unavailable ${failure.runtimeType}'),
      (_) => AppLogger.debug(_source, 'session ready'),
    );
  }

  @disposeMethod
  Future<void> dispose() async => _subscription?.cancel();
}
