import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

class HomeQuickAction extends StatelessWidget {
  const HomeQuickAction({required this.icon, required this.label, required this.onTap, super.key});

  final AppIcon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.lgAll, boxShadow: AppShadows.card),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
            child: Column(
              spacing: AppSpacing.sm,
              children: [
                IconBadge(
                  icon: icon,
                  size: AppSizes.iconBadgeLarge,
                  isCircle: false,
                  background: colors.primarySurface,
                  foreground: colors.primary,
                ),
                Text(
                  label,
                  style: AppTextStyles.captionStrong.copyWith(color: colors.textPrimary),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
