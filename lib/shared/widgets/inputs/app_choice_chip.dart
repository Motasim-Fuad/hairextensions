import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/inputs/choice_chip_variant.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.variant = ChoiceChipVariant.primary,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ChoiceChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedBackground = variant == ChoiceChipVariant.primary ? colors.primary : colors.inverseSurface;
    final selectedForeground = variant == ChoiceChipVariant.primary ? colors.onPrimary : colors.onInverseSurface;
    return Semantics(
      button: true,
      selected: isSelected,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
        child: Center(
          widthFactor: 1,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadius.pillAll,
              child: AnimatedContainer(
                duration: context.motion(AppMotion.fast),
                height: AppSizes.chipHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? selectedBackground : colors.surface,
                  borderRadius: AppRadius.pillAll,
                  border: Border.all(color: isSelected ? selectedBackground : colors.border),
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    label,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: isSelected ? selectedForeground : colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
