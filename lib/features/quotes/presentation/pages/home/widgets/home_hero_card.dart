import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_month_summary.dart';
import 'package:hairextensions/shared/widgets/animations/animated_amount_text.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.summary, required this.currency, super.key});

  static const double _chipAlpha = 0.15;
  static const double _labelAlpha = 0.8;

  final QuoteMonthSummary summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final onHero = colors.onPrimary;
    final perHour = summary.profitPerHourMinor;
    final change = summary.changePercent;
    final previous = summary.previousMonth;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: colors.heroGradient,
        borderRadius: AppRadius.heroAll,
        boxShadow: AppShadows.floating,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeQuotedThisMonth,
                    style: AppTextStyles.overline.copyWith(color: onHero.withValues(alpha: _labelAlpha)),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: onHero.withValues(alpha: _chipAlpha),
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.chipX, vertical: AppSpacing.xs),
                    child: Text(
                      DateFormatter.monthName(summary.month),
                      style: AppTextStyles.chip.copyWith(color: onHero),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedAmountText(
              minor: summary.quotedMinor,
              format: (minor) => MoneyFormatter.format(minor, currency, showDecimals: false),
              style: AppTextStyles.heroAmount.copyWith(color: onHero),
            ),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (perHour != null)
                  DecoratedBox(
                    decoration: BoxDecoration(color: colors.gold, borderRadius: AppRadius.pillAll),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.chipX, vertical: AppSpacing.xs),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: AppSpacing.xs,
                        children: [
                          AppSvgIcon(AppIcon.crown, size: AppSizes.iconXs, color: onHero),
                          Text(
                            l10n.homeAvgProfitPerHour(MoneyFormatter.format(perHour, currency, showDecimals: false)),
                            style: AppTextStyles.chip.copyWith(color: onHero),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (change != null && previous != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      AppSvgIcon(AppIcon.trend, size: AppSizes.iconSm, color: onHero),
                      Text(
                        l10n.homeChangeVsMonth(
                          change >= 0 ? l10n.signedPositive(change) : l10n.signedNegative(change.abs()),
                          DateFormatter.monthShort(previous),
                        ),
                        style: AppTextStyles.chip.copyWith(color: onHero),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
