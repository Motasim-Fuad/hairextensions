import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';

/// Pro entitlement for guards and lock sheets. Reads are synchronous so the
/// router never waits on the store.
abstract interface class SubscriptionService implements Listenable {
  SubscriptionStatus get status;

  bool get isPro;

  Future<void> save(SubscriptionStatus status);
}
