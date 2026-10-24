import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_status_text.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/relative_day_text.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';

class QuoteListTile extends StatelessWidget {
  const QuoteListTile({required this.quote, required this.now, required this.onTap, super.key});

  final Quote quote;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardGap),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          IconBadge(
            icon: AppIcon.user,
            size: AppSizes.avatar,
            background: colors.primarySurface,
            foreground: colors.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  quote.clientName,
                  style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  [quote.number, quote.createdAt.relativeDay(l10n, now)].join(l10n.separatorDot),
                  style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppSpacing.xs,
            children: [
              Text(
                MoneyFormatter.format(quote.totals.totalMinor, quote.currencyCode, showDecimals: false),
                style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary),
              ),
              AppStatusChip(label: quote.status.label(l10n), tone: quote.status.tone),
            ],
          ),
        ],
      ),
    );
  }
}
