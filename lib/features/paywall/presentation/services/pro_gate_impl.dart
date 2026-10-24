import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/contracts/pro_gate.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/pro_lock_sheet.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProGate)
class ProGateImpl implements ProGate {
  ProGateImpl(this._subscription, this._flags);

  final SubscriptionService _subscription;
  final FeatureFlagService _flags;

  @override
  Future<bool> ensurePro(BuildContext context) async {
    if (_subscription.isPro || !_flags.isEnabled(FeatureKey.subscriptions)) {
      return true;
    }
    final restored = await AppBottomSheet.show<bool>(
      context,
      builder: (_) => BlocProvider(
        create: (_) => getIt<PaywallCubit>(),
        child: ProLockSheet(hasExpired: _subscription.status == SubscriptionStatus.expired),
      ),
    );
    if (restored == false && context.mounted) {
      await context.pushNamed<void>(AppRoutes.paywall);
    }
    return _subscription.isPro;
  }
}
