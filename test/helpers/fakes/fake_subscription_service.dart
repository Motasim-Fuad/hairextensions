import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';

class FakeSubscriptionService extends ChangeNotifier implements SubscriptionService {
  FakeSubscriptionService([this.status = SubscriptionStatus.none]);

  @override
  SubscriptionStatus status;

  @override
  bool get isPro => status.isPro;

  @override
  Future<void> save(SubscriptionStatus status) async {
    this.status = status;
    notifyListeners();
  }
}
