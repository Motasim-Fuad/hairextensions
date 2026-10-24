import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/onboarding/presentation/constants/onboarding_sample.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_card.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_line_row.dart';

class QuoteBreakdownShowcase extends StatelessWidget {
  const QuoteBreakdownShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return ShowcaseCard(
      children: [
        ShowcaseLineRow(
          icon: AppIcon.package,
          label: l10n.sampleLineHair(OnboardingSample.hairGrams),
          value: MoneyFormatter.plain(OnboardingSample.hairMinor),
        ),
        ShowcaseLineRow(
          icon: AppIcon.scissors,
          label: l10n.sampleLineInstall(OnboardingSample.installHours),
          value: MoneyFormatter.plain(OnboardingSample.installMinor),
        ),
        ShowcaseLineRow(
          icon: AppIcon.wallet,
          label: l10n.labelMaterials,
          value: MoneyFormatter.plain(OnboardingSample.materialsMinor),
        ),
        ShowcaseLineRow(
          icon: AppIcon.percent,
          label: l10n.vatRateLabel(OnboardingSample.vatRate),
          value: MoneyFormatter.plain(OnboardingSample.vatMinor),
        ),
        Divider(color: colors.border),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.labelTotal, style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary)),
            Text(
              MoneyFormatter.format(OnboardingSample.totalMinor, OnboardingSample.currency, showDecimals: false),
              style: AppTextStyles.displayName.copyWith(color: colors.primary),
            ),
          ],
        ),
      ],
    );
  }
}
