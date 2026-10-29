import 'package:flutter/material.dart';
import 'package:hairextensions/core/contracts/pro_gate.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:injectable/injectable.dart';

/// Business screens never interrupt their flow with a paywall.
@LazySingleton(as: ProGate)
class ProGateImpl implements ProGate {
  ProGateImpl(SubscriptionService subscription, FeatureFlagService flags);
  @override
  Future<bool> ensurePro(BuildContext context) async => true;
}
