import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/paywall/domain/entities/paywall_plan.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_failure.dart';

class PaywallState extends Equatable {
  const PaywallState({
    this.plan = PaywallPlan.annual,
    this.isPurchasing = false,
    this.isUnlocked = false,
    this.failure,
  });

  final PaywallPlan plan;
  final bool isPurchasing;
  final bool isUnlocked;
  final PaywallFailure? failure;

  PaywallState copyWith({PaywallPlan? plan, bool? isPurchasing, bool? isUnlocked, PaywallFailure? failure}) {
    return PaywallState(
      plan: plan ?? this.plan,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [plan, isPurchasing, isUnlocked, failure];
}
