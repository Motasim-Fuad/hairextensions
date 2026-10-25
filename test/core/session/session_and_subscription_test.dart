import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/session/key_value_app_session.dart';
import 'package:hairextensions/core/subscription/cached_subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';

import '../../helpers/fakes/in_memory_key_value_store.dart';

void main() {
  group('KeyValueAppSession', () {
    test('starts with nothing done and persists each step', () async {
      final store = InMemoryKeyValueStore();
      final session = KeyValueAppSession(store);
      expect(session.onboardingSeen, isFalse);
      expect(session.setupCompleted, isFalse);

      await session.markOnboardingSeen();
      await session.markSetupCompleted();

      expect(store.peekBool(StorageKeys.onboardingSeen), isTrue);
      expect(KeyValueAppSession(store).setupCompleted, isTrue);
    });

    test('signing out also resets setup so the next account decides for itself', () async {
      final store = InMemoryKeyValueStore();
      final session = KeyValueAppSession(store);
      await session.markSetupCompleted();
      await session.markSignedIn();
      expect(session.signedIn, isTrue);

      await session.markSignedOut();

      expect(KeyValueAppSession(store).signedIn, isFalse);
      expect(KeyValueAppSession(store).setupCompleted, isFalse);
    });
  });

  group('CachedSubscriptionService', () {
    test('defaults to free and survives restarts', () async {
      final store = InMemoryKeyValueStore();
      final service = CachedSubscriptionService(store);
      expect(service.status, SubscriptionStatus.none);
      expect(service.isPro, isFalse);

      await service.save(SubscriptionStatus.active);

      expect(CachedSubscriptionService(store).isPro, isTrue);
    });

    test('notifies only when the status changes', () async {
      final service = CachedSubscriptionService(InMemoryKeyValueStore());
      var notifications = 0;
      service.addListener(() => notifications++);

      await service.save(SubscriptionStatus.active);
      await service.save(SubscriptionStatus.active);
      await service.save(SubscriptionStatus.expired);

      expect(notifications, 2);
    });

    test('unknown stored values fall back to free', () {
      final store = InMemoryKeyValueStore({StorageKeys.subscriptionStatus: 'lifetime'});
      expect(CachedSubscriptionService(store).status, SubscriptionStatus.none);
    });
  });
}
