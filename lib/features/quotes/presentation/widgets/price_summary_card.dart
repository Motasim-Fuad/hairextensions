import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// Pink result card: the client price large, with an optional side figure
/// such as profit.
class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({
    required this.label,
    required this.amount,
    super.key,
    this.sideLabel,
    this.sideValue,
  });

  final String label;
  final String amount;
  final String? sideLabel;
  final String? sideValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.primarySoft, borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.detail.copyWith(color: colors.primaryStrong)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(amount, style: AppTextStyles.highlightAmount.copyWith(color: colors.primaryStrong)),
                  ),
                ],
              ),
            ),
            if (sideLabel != null && sideValue != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(sideLabel!, style: AppTextStyles.caption.copyWith(color: colors.primaryStrong)),
                  Text(sideValue!, style: AppTextStyles.rowTitle.copyWith(color: colors.success)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
