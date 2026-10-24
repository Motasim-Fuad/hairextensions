import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_field_skeleton.dart';
import 'package:hairextensions/shared/widgets/responsive/max_width_box.dart';
import 'package:hairextensions/shared/widgets/shimmer/shimmer_scope.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_circle.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_line.dart';

/// Mirrors the step layout: heading, logo row, then input fields.
class SetupSkeleton extends StatelessWidget {
  const SetupSkeleton({super.key});

  static const double _titleHeight = 28;
  static const double _titleWidthFactor = 0.7;
  static const double _subtitleWidthFactor = 0.9;
  static const double _logoTitleWidthFactor = 0.5;
  static const double _logoHintWidthFactor = 0.8;
  static const int _fieldCount = 3;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: MaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonLine(widthFactor: _titleWidthFactor, height: _titleHeight),
              const SizedBox(height: AppSpacing.sm),
              const SkeletonLine(widthFactor: _subtitleWidthFactor),
              const SizedBox(height: AppSpacing.xxl),
              const Row(
                children: [
                  SkeletonCircle(size: AppSizes.logoLarge),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(widthFactor: _logoTitleWidthFactor),
                        SizedBox(height: AppSpacing.sm),
                        SkeletonLine(widthFactor: _logoHintWidthFactor),
                      ],
                    ),
                  ),
                ],
              ),
              for (var index = 0; index < _fieldCount; index++) ...[
                const SizedBox(height: AppSpacing.xxl),
                const SetupFieldSkeleton(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
