import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/paywall/domain/entities/paywall_plan.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_failure.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

class PaywallFooter extends StatelessWidget {
  const PaywallFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<PaywallCubit>();
    final separator = Text(
      l10n.middleDot,
      style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
    );
    final linkStyle = TextButton.styleFrom(
      foregroundColor: colors.textSecondary,
      textStyle: AppTextStyles.captionStrong,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.padded,
    );
    return BlocBuilder<PaywallCubit, PaywallState>(
      buildWhen: (previous, current) =>
          previous.isPurchasing != current.isPurchasing ||
          previous.failure != current.failure,
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          AppPrimaryButton(
            label: cubit.billingAvailable
                ? l10n.paywallStartTrial(PaywallPlan.trialDays)
                : 'Subscriptions unavailable',
            isLoading: state.isPurchasing,
            onPressed: cubit.billingAvailable ? cubit.startTrial : null,
            errorText: state.failure == PaywallFailure.purchase
                ? l10n.paywallUnavailable
                : null,
          ),
          if (cubit.billingAvailable)
            Text(
              l10n.paywallRenewal(
                MoneyFormatter.format(
                  PaywallPlan.annual.priceMinor,
                  PaywallPlan.currency,
                ),
              ),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.xs,
                children: [
                  TextButton(
                    onPressed: cubit.billingAvailable ? cubit.restore : null,
                    style: linkStyle.copyWith(
                      foregroundColor: WidgetStatePropertyAll(colors.primary),
                      textStyle: WidgetStatePropertyAll(AppTextStyles.chip),
                    ),
                    child: Text(l10n.actionRestorePurchases),
                  ),
                  separator,
                  TextButton(
                    onPressed: cubit.openTerms,
                    style: linkStyle,
                    child: Text(l10n.linkTerms),
                  ),
                  separator,
                  TextButton(
                    onPressed: cubit.openPrivacy,
                    style: linkStyle,
                    child: Text(l10n.linkPrivacy),
                  ),
                ],
              ),
              InlineErrorText(
                message: state.failure == PaywallFailure.link
                    ? l10n.errorOpenLink
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
