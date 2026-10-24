import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';

/// One tappable segment inside AppSegmentedControl.
class AppSegmentButton extends StatelessWidget {
  const AppSegmentButton({required this.label, required this.isSelected, required this.onTap, super.key});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: context.motion(AppMotion.fast),
              style: context.textTheme.labelMedium!.copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}
