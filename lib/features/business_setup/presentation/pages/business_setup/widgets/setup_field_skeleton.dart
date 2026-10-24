import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_line.dart';

class SetupFieldSkeleton extends StatelessWidget {
  const SetupFieldSkeleton({super.key});

  static const double _labelWidthFactor = 0.3;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(widthFactor: _labelWidthFactor),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: AppSizes.inputHeight, radius: AppRadius.md),
      ],
    );
  }
}
