import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_line_text.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Swipe left to remove a line from the draft.
class BuilderLineTile extends StatelessWidget {
  const BuilderLineTile({required this.line, required this.currency, required this.onRemove, super.key});

  final QuoteLine line;
  final String currency;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Dismissible(
        key: ValueKey(line.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onRemove(),
        background: DecoratedBox(
          decoration: BoxDecoration(color: colors.dangerSoft, borderRadius: AppRadius.mdAll),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSvgIcon(
                AppIcon.trash,
                size: AppSizes.iconMd,
                color: colors.danger,
                semanticLabel: l10n.actionDelete,
              ),
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.background, borderRadius: AppRadius.mdAll),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.displayTitle(l10n),
                            style: AppTextStyles.rowValue.copyWith(color: colors.textPrimary),
                          ),
                          Text(
                            line.detail(l10n, currency),
                            style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      MoneyFormatter.format(line.amountMinor, currency, showDecimals: false),
                      style: AppTextStyles.rowValue.copyWith(color: colors.textPrimary),
                    ),
                  ],
                ),
                Text(line.meta(l10n, currency), style: AppTextStyles.micro.copyWith(color: colors.textTertiary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
