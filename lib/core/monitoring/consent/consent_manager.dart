import 'dart:async';

import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/monitoring/consent/consent_settings.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:injectable/injectable.dart';

/// Analytics and crash collection stay off until the user opts in.
@lazySingleton
class ConsentManager {
  ConsentManager(this._store);

  final KeyValueStore _store;
  final StreamController<ConsentSettings> _changes = StreamController<ConsentSettings>.broadcast();

  Stream<ConsentSettings> get changes => _changes.stream;

  ConsentSettings get current => ConsentSettings(
    analyticsEnabled: _store.peekBool(StorageKeys.analyticsConsent) ?? false,
    crashReportingEnabled: _store.peekBool(StorageKeys.crashConsent) ?? false,
    hasAnswered: _store.peekBool(StorageKeys.consentAsked) ?? false,
  );

  Future<void> update({required bool analytics, required bool crashReporting}) async {
    await _store.setBool(StorageKeys.analyticsConsent, value: analytics);
    await _store.setBool(StorageKeys.crashConsent, value: crashReporting);
    await _store.setBool(StorageKeys.consentAsked, value: true);
    _changes.add(current);
  }

  @disposeMethod
  Future<void> dispose() => _changes.close();
}
