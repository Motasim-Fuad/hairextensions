import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// "Pack price ........ AED 350.00" row of an illustration card.
class ShowcaseValueRow extends StatelessWidget {
  const ShowcaseValueRow({required this.label, required this.value, super.key, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.detail.copyWith(color: colors.textSecondary)),
        Text(value, style: AppTextStyles.detailStrong.copyWith(color: valueColor ?? colors.textPrimary)),
      ],
    );
  }
}
