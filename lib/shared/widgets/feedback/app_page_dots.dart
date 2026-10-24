import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// Pager position: the active dot stretches into a pill.
class AppPageDots extends StatelessWidget {
  const AppPageDots({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = context.motion(AppMotion.medium);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.dotGap),
          AnimatedContainer(
            duration: duration,
            curve: AppMotion.standard,
            width: i == index ? AppSizes.pageDotActive : AppSizes.pageDot,
            height: AppSizes.pageDot,
            decoration: BoxDecoration(
              color: i == index ? colors.primary : colors.borderStrong,
              borderRadius: AppRadius.xsAll,
            ),
          ),
        ],
      ],
    );
  }
}
