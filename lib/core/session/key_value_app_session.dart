import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:injectable/injectable.dart';

/// Reads rely on [KeyValueStore.warmUp] having completed before runApp.
@LazySingleton(as: AppSession)
class KeyValueAppSession implements AppSession {
  KeyValueAppSession(this._store);

  final KeyValueStore _store;

  @override
  bool get onboardingSeen => _store.peekBool(StorageKeys.onboardingSeen) ?? false;

  @override
  bool get setupCompleted => _store.peekBool(StorageKeys.setupCompleted) ?? false;

  @override
  bool get signedIn => _store.peekBool(StorageKeys.signedIn) ?? false;

  @override
  Future<void> markSignedIn() => _store.setBool(StorageKeys.signedIn, value: true);

  @override
  Future<void> markSignedOut() async {
    await _store.setBool(StorageKeys.signedIn, value: false);
    await _store.setBool(StorageKeys.setupCompleted, value: false);
  }

  @override
  Future<void> markOnboardingSeen() => _store.setBool(StorageKeys.onboardingSeen, value: true);

  @override
  Future<void> markSetupCompleted() => _store.setBool(StorageKeys.setupCompleted, value: true);
}
