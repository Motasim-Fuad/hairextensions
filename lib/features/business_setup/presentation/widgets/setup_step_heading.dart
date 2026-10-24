import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

class SetupStepHeading extends StatelessWidget {
  const SetupStepHeading({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title, style: context.textTheme.headlineLarge)),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}
