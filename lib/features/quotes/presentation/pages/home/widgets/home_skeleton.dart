import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/shimmer/shimmer_scope.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_circle.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_line.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_list_tile.dart';

/// Home-shaped placeholder (design 5.2).
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const double _heroHeight = 168;
  static const double _tileHeight = 76;
  static const double _nameWidth = 0.4;
  static const int _rows = 3;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const Row(
            spacing: AppSpacing.md,
            children: [
              SkeletonCircle(size: AppSizes.iconBadgeLarge),
              Expanded(child: SkeletonLine(widthFactor: _nameWidth)),
              SkeletonCircle(size: AppSizes.iconBadgeLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          const SkeletonBox(height: _heroHeight, radius: AppRadius.hero),
          const SizedBox(height: AppSpacing.lg),
          const Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: SkeletonBox(height: _tileHeight, radius: AppRadius.lg),
              ),
              Expanded(
                child: SkeletonBox(height: _tileHeight, radius: AppRadius.lg),
              ),
              Expanded(
                child: SkeletonBox(height: _tileHeight, radius: AppRadius.lg),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          for (var index = 0; index < _rows; index++) const SkeletonListTile(),
        ],
      ),
    );
  }
}
