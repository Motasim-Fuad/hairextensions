import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/shared/widgets/animations/animated_amount_text.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';

/// Sticky footer of the builder: live total and balance, then review.
class BuilderTotalBar extends StatelessWidget {
  const BuilderTotalBar({
    required this.totalMinor,
    required this.balanceMinor,
    required this.currency,
    required this.onReview,
    super.key,
  });

  final int totalMinor;
  final int balanceMinor;
  final String currency;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    String money(int minor) => MoneyFormatter.format(minor, currency);
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, boxShadow: AppShadows.bottomNav),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.labelTotal, style: AppTextStyles.detail.copyWith(color: colors.textSecondary)),
                        AnimatedAmountText(
                          minor: totalMinor,
                          format: money,
                          style: AppTextStyles.highlightAmount.copyWith(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l10n.labelBalance, style: AppTextStyles.detail.copyWith(color: colors.textSecondary)),
                      Text(money(balanceMinor), style: AppTextStyles.rowTitle.copyWith(color: colors.primary)),
                    ],
                  ),
                ],
              ),
              AppPrimaryButton(label: l10n.actionReviewQuote, trailingIcon: AppIcon.chevronRight, onPressed: onReview),
            ],
          ),
        ),
      ),
    );
  }
}
