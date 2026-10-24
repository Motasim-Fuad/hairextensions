import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

/// Quote line with a small icon badge, used by the quote breakdown sample.
class ShowcaseLineRow extends StatelessWidget {
  const ShowcaseLineRow({required this.icon, required this.label, required this.value, super.key});

  final AppIcon icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: AppSpacing.chipX,
      children: [
        IconBadge(icon: icon, size: AppSizes.iconBadgeSmall, background: colors.primarySurface),
        Expanded(
          child: Text(label, style: AppTextStyles.rowLabel.copyWith(color: colors.textPrimary)),
        ),
        Text(value, style: AppTextStyles.rowValue.copyWith(color: colors.textPrimary)),
      ],
    );
  }
}
