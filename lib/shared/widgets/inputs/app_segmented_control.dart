import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segment_button.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';

/// Pill toggle (Quote or Invoice, Whole pack or Exact grams, percent or
/// fixed). The highlight slides with an implicit animation.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({required this.options, required this.selected, required this.onChanged, super.key});

  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = options.length;
    final index = options.indexWhere((option) => option.value == selected).clamp(0, count - 1);
    final x = count == 1 ? 0.0 : -1 + (2 * index / (count - 1));
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: AppRadius.mdAll),
      child: SizedBox(
        height: AppSizes.segmentHeight,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: context.motion(AppMotion.medium),
                curve: AppMotion.standard,
                alignment: Alignment(x, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / count,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.smAll),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final option in options)
                    Expanded(
                      child: AppSegmentButton(
                        label: option.label,
                        isSelected: option.value == selected,
                        onTap: () {
                          if (option.value != selected) {
                            onChanged(option.value);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
