import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';
import 'package:injectable/injectable.dart';

/// Last known entitlement, kept so the app works offline. It is a cache, not
/// proof of purchase: the subscription feature verifies with the store and
/// overwrites it through [save].
@LazySingleton(as: SubscriptionService)
class CachedSubscriptionService extends ChangeNotifier implements SubscriptionService {
  CachedSubscriptionService(this._store);

  final KeyValueStore _store;

  @override
  SubscriptionStatus get status => SubscriptionStatus.fromName(_store.peekString(StorageKeys.subscriptionStatus));

  @override
  bool get isPro => status.isPro;

  @override
  Future<void> save(SubscriptionStatus status) async {
    if (status == this.status) {
      return;
    }
    await _store.setString(StorageKeys.subscriptionStatus, status.name);
    notifyListeners();
  }
}
