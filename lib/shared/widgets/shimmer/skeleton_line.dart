import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';

/// Text-line placeholder sized as a fraction of the available width.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.widthFactor = 1, this.height = AppSizes.skeletonLineHeight});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: SkeletonBox(height: height, radius: AppRadius.xs),
    );
  }
}
