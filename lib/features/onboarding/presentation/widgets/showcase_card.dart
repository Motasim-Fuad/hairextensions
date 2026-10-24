import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// Floating white card inside an onboarding illustration.
class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({required this.children, super.key, this.gap = AppSpacing.md});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.xlAll,
        boxShadow: AppShadows.showcase,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: children,
        ),
      ),
    );
  }
}
