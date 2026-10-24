import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

class ShareChannelButton extends StatelessWidget {
  const ShareChannelButton({required this.icon, required this.label, required this.onTap, super.key});

  final AppIcon icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            IconBadge(
              icon: icon,
              size: AppSizes.iconBadgeLarge,
              background: colors.primarySurface,
              foreground: colors.primary,
            ),
            Text(label, style: AppTextStyles.captionStrong.copyWith(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
