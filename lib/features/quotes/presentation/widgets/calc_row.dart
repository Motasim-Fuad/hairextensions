import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// Compact label/value row used inside calculation cards and breakdowns.
class CalcRow extends StatelessWidget {
  const CalcRow({required this.label, required this.value, super.key, this.isStrong = false, this.valueColor});

  final String label;
  final String value;
  final bool isStrong;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelStyle = (isStrong ? AppTextStyles.rowValue : AppTextStyles.detail).copyWith(
      color: isStrong ? colors.textPrimary : colors.textSecondary,
    );
    final valueStyle = (isStrong ? AppTextStyles.rowValue : AppTextStyles.detailStrong).copyWith(
      color: valueColor ?? colors.textPrimary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}
