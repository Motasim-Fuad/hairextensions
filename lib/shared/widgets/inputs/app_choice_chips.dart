import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chip.dart';
import 'package:hairextensions/shared/widgets/inputs/choice_chip_variant.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';

/// Single-select chip group that wraps onto new lines on narrow screens.
class AppChoiceChips<T> extends StatelessWidget {
  const AppChoiceChips({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
    this.variant = ChoiceChipVariant.primary,
  });

  final List<SegmentOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final ChoiceChipVariant variant;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final option in options)
          AppChoiceChip(
            label: option.label,
            isSelected: option.value == selected,
            variant: variant,
            onTap: () => onChanged(option.value),
          ),
      ],
    );
  }
}
