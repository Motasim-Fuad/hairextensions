import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

class QuoteActivityTile extends StatelessWidget {
  const QuoteActivityTile({required this.icon, required this.title, required this.subtitle, super.key});

  final AppIcon icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          IconBadge(
            icon: icon,
            size: AppSizes.iconBadgeSmall,
            background: colors.primarySurface,
            foreground: colors.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.rowLabel.copyWith(color: colors.textPrimary)),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: colors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
