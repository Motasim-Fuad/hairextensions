import 'dart:async';

import 'package:hairextensions/core/contracts/account_restorer.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Keeps the signed-in state honest. Ends the session when the API rejects the
/// bearer token, and on start when the stored token is missing or past its
/// expiry. The router then sends the stylist to the login screen.
///
/// The class keeps its original name so the bootstrap wiring does not change.
@lazySingleton
class DeviceSessionStarter {
  DeviceSessionStarter(
    this._auth,
    this._expiry,
    this._session,
    this._tokens,
    this._restorer,
  );

  static const String _source = 'SessionWatcher';

  final AuthRepository _auth;
  final SessionExpiryNotifier _expiry;
  final AppSession _session;
  final SecureTokenStore _tokens;
  final AccountRestorer _restorer;
  StreamSubscription<void>? _subscription;

  Future<void> start() async {
    _subscription ??= _expiry.onExpired.listen(
      (_) => unawaited(_auth.endSession()),
    );
    if (!_session.signedIn) {
      return;
    }
    final tokens = await _tokens.read();
    if (tokens == null ||
        (tokens.refreshToken == null &&
            tokens.isExpired(DateTime.now().toUtc()))) {
      AppLogger.warning(
        _source,
        'stored token missing or expired, signing out',
      );
      await _auth.endSession();
      return;
    }
    await _restorer.syncMissingBusiness();
  }

  @disposeMethod
  Future<void> dispose() async => _subscription?.cancel();
}
