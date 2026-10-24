import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// Overline label above a bold figure, for example "TOTAL / AED 2,104".
class AmountStat extends StatelessWidget {
  const AmountStat({required this.label, required this.value, super.key, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xxs,
      children: [
        Text(label, style: AppTextStyles.overline.copyWith(color: colors.textTertiary)),
        Text(
          value,
          style: AppTextStyles.rowTitle.copyWith(color: valueColor ?? colors.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
