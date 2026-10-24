import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/dashed_border_painter.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// "+ Add hair" style button used inside quote builder sections.
class DashedAddButton extends StatelessWidget {
  const DashedAddButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      child: CustomPaint(
        painter: DashedBorderPainter(color: colors.primaryBorder, radius: AppRadius.md),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.mdAll,
            child: SizedBox(
              height: AppSizes.dashedButtonHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSvgIcon(AppIcon.plus, size: AppSizes.iconMd, color: colors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(label, style: context.textTheme.labelLarge?.copyWith(color: colors.primary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
