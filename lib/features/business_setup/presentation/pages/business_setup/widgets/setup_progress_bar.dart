import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// One segment per step; segments up to and including [current] are filled.
class SetupProgressBar extends StatelessWidget {
  const SetupProgressBar({required this.current, required this.total, super.key});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = context.motion(AppMotion.medium);
    return Row(
      children: [
        for (var index = 0; index < total; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AnimatedContainer(
              duration: duration,
              curve: AppMotion.standard,
              height: AppSizes.progressSegmentHeight,
              decoration: BoxDecoration(
                color: index <= current ? colors.primary : colors.border,
                borderRadius: AppRadius.pillAll,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
