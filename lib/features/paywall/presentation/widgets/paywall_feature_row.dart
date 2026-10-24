import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class PaywallFeatureRow extends StatelessWidget {
  const PaywallFeatureRow({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: AppSpacing.md,
      children: [
        SizedBox.square(
          dimension: AppSizes.checkBadge,
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            child: Center(
              child: AppSvgIcon(AppIcon.check, size: AppSizes.iconXs, color: colors.onPrimary),
            ),
          ),
        ),
        Expanded(
          child: Text(label, style: AppTextStyles.feature.copyWith(color: colors.textPrimary)),
        ),
      ],
    );
  }
}
