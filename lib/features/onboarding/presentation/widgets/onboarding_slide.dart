import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// Pink illustration panel followed by the headline and body copy. The panel
/// shrinks on short screens and its card scales down instead of overflowing.
class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({required this.illustration, required this.title, required this.body, super.key});

  final Widget illustration;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SizedBox(
              height: AppSizes.showcaseHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: colors.primarySoft, borderRadius: AppRadius.xxlAll),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(width: constraints.maxWidth, child: illustration),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(title, style: AppTextStyles.pageTitle.copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppSpacing.chipX),
          Text(body, style: AppTextStyles.paragraph.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}
