import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/onboarding/presentation/constants/onboarding_sample.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_card.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_value_row.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

class CostPerGramShowcase extends StatelessWidget {
  const CostPerGramShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    const currency = OnboardingSample.currency;
    final grams = OnboardingSample.gramsPerPack.toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.cardGap,
      children: [
        ShowcaseCard(
          children: [
            Row(
              spacing: AppSpacing.md,
              children: [
                const IconBadge(icon: AppIcon.package, size: AppSizes.iconBadgeLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      Text(l10n.sampleProductName, style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary)),
                      Text(
                        l10n.sampleProductMeta(OnboardingSample.gramsPerPack),
                        style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: colors.border),
            ShowcaseValueRow(
              label: l10n.labelPackPrice,
              value: MoneyFormatter.format(OnboardingSample.packPriceMinor, currency),
            ),
            ShowcaseValueRow(label: l10n.labelGramsPerPack, value: l10n.gramsValue(grams)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.labelCostPerGram, style: AppTextStyles.detailStrong.copyWith(color: colors.textPrimary)),
                Text(
                  MoneyFormatter.format(OnboardingSample.costPerGramMinor, currency),
                  style: AppTextStyles.highlightAmount.copyWith(color: colors.primary),
                ),
              ],
            ),
          ],
        ),
        Text(
          l10n.onboardingCostFormula(
            MoneyFormatter.plain(OnboardingSample.packPriceMinor),
            grams,
            MoneyFormatter.plain(OnboardingSample.costPerGramMinor, showDecimals: true),
          ),
          style: AppTextStyles.detailAccent.copyWith(color: colors.primaryStrong),
        ),
      ],
    );
  }
}
