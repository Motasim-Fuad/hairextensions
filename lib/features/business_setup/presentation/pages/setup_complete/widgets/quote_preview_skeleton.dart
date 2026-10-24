import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';
import 'package:hairextensions/shared/widgets/shimmer/shimmer_scope.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_line.dart';

class QuotePreviewSkeleton extends StatelessWidget {
  const QuotePreviewSkeleton({super.key});

  static const double _titleHeight = 28;
  static const double _titleWidthFactor = 0.7;
  static const double _nameWidthFactor = 0.6;
  static const int _rowCount = 5;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Column(
        children: [
          const SkeletonLine(widthFactor: _titleWidthFactor, height: _titleHeight),
          const SizedBox(height: AppSpacing.xxl),
          SectionCard(
            child: Column(
              children: [
                const Row(
                  children: [
                    SkeletonBox(width: AppSizes.logo, height: AppSizes.logo),
                    SizedBox(width: AppSpacing.md),
                    Expanded(child: SkeletonLine(widthFactor: _nameWidthFactor)),
                  ],
                ),
                for (var index = 0; index < _rowCount; index++) ...[
                  const SizedBox(height: AppSpacing.md),
                  const SkeletonLine(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
