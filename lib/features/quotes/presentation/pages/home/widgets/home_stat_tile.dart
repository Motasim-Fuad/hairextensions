import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

class HomeStatTile extends StatelessWidget {
  const HomeStatTile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.lgAll, boxShadow: AppShadows.card),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            Text(label, style: AppTextStyles.overline.copyWith(color: colors.textTertiary)),
            Text(value, style: AppTextStyles.statValue.copyWith(color: colors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
