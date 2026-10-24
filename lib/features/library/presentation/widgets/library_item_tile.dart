import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';

/// Library row: icon, title with two detail lines, optional price chip.
class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.detail,
    this.chipLabel,
    this.chipCaption,
    this.onTap,
  });

  final AppIcon icon;
  final String title;
  final String subtitle;
  final String? detail;
  final String? chipLabel;
  final String? chipCaption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardGap),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          IconBadge(
            icon: icon,
            size: AppSizes.iconBadgeLarge,
            isCircle: false,
            background: colors.primarySurface,
            foreground: colors.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(title, style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary)),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: colors.textSecondary)),
                if (detail != null) Text(detail!, style: AppTextStyles.caption.copyWith(color: colors.textTertiary)),
              ],
            ),
          ),
          if (chipLabel != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppSpacing.xxs,
              children: [
                AppStatusChip(label: chipLabel!, tone: StatusTone.primary),
                if (chipCaption != null)
                  Text(chipCaption!, style: AppTextStyles.micro.copyWith(color: colors.textTertiary)),
              ],
            ),
        ],
      ),
    );
  }
}
