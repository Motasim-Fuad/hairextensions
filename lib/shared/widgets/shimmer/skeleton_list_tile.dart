import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_circle.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_line.dart';

/// Mirrors the quote, product and settings row layout: badge, two lines of
/// text and a trailing amount with a chip.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key, this.showTrailing = true});

  static const double _titleFactor = 0.6;
  static const double _subtitleFactor = 0.4;
  static const double _trailingWidth = 64;
  static const double _chipWidth = 44;
  static const double _chipHeight = 16;

  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.surface, borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const SkeletonCircle(size: AppSizes.iconBadge),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(widthFactor: _titleFactor),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonLine(widthFactor: _subtitleFactor),
                ],
              ),
            ),
            if (showTrailing)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(width: _trailingWidth, height: AppSizes.skeletonLineHeight),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(width: _chipWidth, height: _chipHeight, radius: AppRadius.pill),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
