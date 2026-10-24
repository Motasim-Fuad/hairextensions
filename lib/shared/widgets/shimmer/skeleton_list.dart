import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/shimmer/shimmer_scope.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_list_tile.dart';

/// Ready-made shimmering list for list pages (quotes, library, search).
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 6, this.padding = const EdgeInsets.all(AppSpacing.xl)});

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, _) => const SkeletonListTile(),
      ),
    );
  }
}
