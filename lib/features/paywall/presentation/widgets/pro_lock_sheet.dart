import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/paywall/domain/entities/paywall_plan.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/plan_option_card.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

/// Pops `true` when Pro was restored in place, `false` when the stylist
/// chose to see the full paywall, and null on "Not now".
class ProLockSheet extends StatelessWidget {
  const ProLockSheet({required this.hasExpired, super.key});

  final bool hasExpired;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    const plan = PaywallPlan.annual;
    return BlocListener<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) => !previous.isUnlocked && current.isUnlocked,
      listener: (context, _) => Navigator.of(context).pop(true),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.lg,
            children: [
              IconBadge(
                icon: AppIcon.lock,
                size: AppSizes.iconBadgeHero,
                background: colors.primarySoft,
                foreground: colors.primary,
              ),
              Text(
                hasExpired ? l10n.proLockExpiredTitle : l10n.proLockTitle,
                style: AppTextStyles.displayName.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ),
              Text(
                l10n.proLockMessage,
                style: AppTextStyles.paragraph.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              PlanOptionCard(
                title: l10n.proLockPlan(MoneyFormatter.format(plan.priceMinor, PaywallPlan.currency)),
                detail: l10n.proLockPlanDetail(MoneyFormatter.format(plan.monthlyMinor, PaywallPlan.currency)),
                price: '',
                isSelected: true,
                onTap: () {},
              ),
              BlocSelector<PaywallCubit, PaywallState, bool>(
                selector: (state) => state.failure != null,
                builder: (context, hasFailure) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.sm,
                  children: [
                    AppPrimaryButton(
                      label: hasExpired ? l10n.proLockRenew : l10n.proLockUnlock,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    if (hasFailure) InlineErrorText(message: l10n.paywallUnavailable),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLinkButton(
                    label: l10n.actionRestorePurchases,
                    color: colors.textSecondary,
                    onPressed: () => context.read<PaywallCubit>().restore(),
                  ),
                  Text(l10n.middleDot, style: AppTextStyles.caption.copyWith(color: colors.textTertiary)),
                  AppLinkButton(
                    label: l10n.actionNotNow,
                    color: colors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
