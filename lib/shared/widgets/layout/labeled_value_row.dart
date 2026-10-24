import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// "Label ... value" line used in calculations, breakdowns and previews.
class LabeledValueRow extends StatelessWidget {
  const LabeledValueRow({
    required this.label,
    required this.value,
    super.key,
    this.caption,
    this.isEmphasized = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? caption;
  final bool isEmphasized;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = context.textTheme;
    final labelStyle = isEmphasized ? text.titleSmall : text.bodyMedium?.copyWith(color: context.colors.textSecondary);
    final valueStyle = (isEmphasized ? text.titleSmall : text.labelMedium)?.copyWith(color: valueColor);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: labelStyle),
                  if (caption != null) Text(caption!, style: text.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(value, style: valueStyle, textAlign: TextAlign.end),
          ],
        ),
      ),
    );
  }
}
