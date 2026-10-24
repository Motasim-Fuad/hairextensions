import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/amount_stat.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Private profit panel on review (never printed on the client PDF).
class ProfitCard extends StatelessWidget {
  const ProfitCard({required this.quote, required this.showFormulas, required this.onToggleFormulas, super.key});

  final Quote quote;
  final bool showFormulas;
  final VoidCallback onToggleFormulas;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final totals = quote.totals;
    final currency = quote.currencyCode;
    final perHour = totals.profitPerHourMinor;
    String plain(int minor) => MoneyFormatter.plain(minor);
    final costParts = [
      for (final category in LineCategory.values)
        if (quote.linesIn(category).any((line) => line.costMinor > 0))
          l10n.formulaCostPart(
            category.name,
            plain(quote.linesIn(category).fold(0, (sum, line) => sum + line.costMinor)),
          ),
    ];
    final hours = PercentFormatter.format(totals.hours);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.goldSoft,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.goldBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                AppSvgIcon(AppIcon.crown, size: AppSizes.iconSm, color: colors.goldDeep),
                Expanded(
                  child: Text(l10n.reviewYourProfit, style: AppTextStyles.overline.copyWith(color: colors.goldDeep)),
                ),
                Text(l10n.reviewOnlyYou, style: AppTextStyles.caption.copyWith(color: colors.goldDeep)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  MoneyFormatter.format(perHour ?? totals.profitMinor, currency, showDecimals: false),
                  style: AppTextStyles.heroAmount.copyWith(color: colors.textPrimary),
                ),
                if (perHour != null)
                  Text(l10n.reviewPerBookedHour, style: AppTextStyles.detail.copyWith(color: colors.textSecondary)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AmountStat(
                    label: l10n.statCosts,
                    value: MoneyFormatter.format(totals.costsMinor, currency, showDecimals: false),
                  ),
                ),
                Expanded(
                  child: AmountStat(
                    label: l10n.statProfit,
                    value: MoneyFormatter.format(totals.profitMinor, currency, showDecimals: false),
                    valueColor: colors.success,
                  ),
                ),
                Expanded(
                  child: AmountStat(
                    label: l10n.statMargin,
                    value: l10n.percentValue(totals.marginPercent.round().toString()),
                  ),
                ),
                Expanded(
                  child: AmountStat(label: l10n.statHours, value: l10n.hoursValue(hours)),
                ),
              ],
            ),
            InkWell(
              onTap: onToggleFormulas,
              child: Row(
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    showFormulas ? l10n.reviewHideFormulas : l10n.reviewShowFormulas,
                    style: AppTextStyles.link.copyWith(color: colors.goldDeep),
                  ),
                  AppSvgIcon(
                    showFormulas ? AppIcon.chevronUp : AppIcon.chevronDown,
                    size: AppSizes.iconSm,
                    color: colors.goldDeep,
                  ),
                ],
              ),
            ),
            if (showFormulas)
              Text(
                [
                  l10n.formulaCosts(costParts.join(' + '), plain(totals.costsMinor)),
                  l10n.formulaProfit(
                    plain(totals.totalMinor),
                    plain(totals.vatMinor),
                    plain(totals.costsMinor),
                    plain(totals.profitMinor),
                  ),
                  if (perHour != null)
                    l10n.formulaPerHour(
                      plain(totals.profitMinor),
                      hours,
                      MoneyFormatter.plain(perHour, showDecimals: true),
                    ),
                ].join('\n'),
                style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
