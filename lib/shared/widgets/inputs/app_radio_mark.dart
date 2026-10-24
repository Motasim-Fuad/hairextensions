import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';

/// Visual radio indicator for custom option cards; the card owns the tap.
class AppRadioMark extends StatelessWidget {
  const AppRadioMark({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: context.motion(AppMotion.fast),
      width: AppSizes.radio,
      height: AppSizes.radio,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colors.primary : colors.surface,
        border: Border.all(
          color: isSelected ? colors.primary : colors.borderStrong,
          width: AppSizes.radioBorder,
        ),
      ),
      child: isSelected
          ? Center(
              child: SizedBox.square(
                dimension: AppSizes.radioDot,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                ),
              ),
            )
          : null,
    );
  }
}
