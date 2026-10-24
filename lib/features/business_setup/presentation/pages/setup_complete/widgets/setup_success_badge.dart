import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class SetupSuccessBadge extends StatelessWidget {
  const SetupSuccessBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.primarySoft, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            child: SizedBox.square(
              dimension: AppSizes.successBadge,
              child: AppSvgIcon(AppIcon.check, size: AppSizes.iconLg * 2, color: colors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
