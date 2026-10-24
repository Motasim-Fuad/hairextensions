import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Raised round "+" in the middle of the bottom navigation.
class AppCenterActionButton extends StatelessWidget {
  const AppCenterActionButton({required this.semanticLabel, required this.onPressed, super.key});

  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: AppShadows.floating),
        child: Material(
          color: colors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: AppSizes.fabSize,
              child: AppSvgIcon(AppIcon.plus, color: colors.onPrimary, size: AppSizes.iconLg),
            ),
          ),
        ),
      ),
    );
  }
}
