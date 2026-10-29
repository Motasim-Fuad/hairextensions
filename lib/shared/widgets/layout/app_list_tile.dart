import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Settings style row: icon badge, title, optional value and chevron.
class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.trailingText,
    this.isDestructive = false,
    this.showChevron = true,
  });

  final AppIcon icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleColor = isDestructive ? colors.danger : colors.textPrimary;
    return MergeSemantics(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.listTileMinHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconBadge(
                    icon: icon,
                    background: isDestructive ? colors.dangerSoft : null,
                    foreground: isDestructive ? colors.danger : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: titleColor,
                          ),
                        ),
                        if (subtitle != null)
                          Text(subtitle!, style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (trailingText != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        trailingText!,
                        style: context.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  if (showChevron) ...[
                    const SizedBox(width: AppSpacing.xs),
                    AppSvgIcon(
                      AppIcon.chevronRight,
                      size: AppSizes.iconMd,
                      color: colors.textTertiary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
