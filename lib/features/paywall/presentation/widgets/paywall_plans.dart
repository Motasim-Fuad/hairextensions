import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/paywall/domain/entities/paywall_plan.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/plan_option_card.dart';

class PaywallPlans extends StatelessWidget {
  const PaywallPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PaywallCubit>();
    String money(int minor) => MoneyFormatter.format(minor, PaywallPlan.currency);
    return BlocSelector<PaywallCubit, PaywallState, PaywallPlan>(
      selector: (state) => state.plan,
      builder: (context, selected) => Column(
        spacing: AppSpacing.md,
        children: [
          PlanOptionCard(
            title: l10n.planAnnual,
            badge: l10n.planBestValue,
            detail: l10n.planAnnualDetail(money(PaywallPlan.annual.monthlyMinor), PaywallPlan.trialDays),
            price: money(PaywallPlan.annual.priceMinor),
            isSelected: selected == PaywallPlan.annual,
            onTap: () => cubit.selectPlan(PaywallPlan.annual),
          ),
          PlanOptionCard(
            title: l10n.planMonthly,
            detail: l10n.planMonthlyDetail,
            price: money(PaywallPlan.monthly.priceMinor),
            isSelected: selected == PaywallPlan.monthly,
            onTap: () => cubit.selectPlan(PaywallPlan.monthly),
          ),
        ],
      ),
    );
  }
}
