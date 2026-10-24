import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class CurrencyOptionTile extends StatelessWidget {
  const CurrencyOptionTile({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.listTileMinHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: AppSizes.iconBadgeLarge,
                    child: Text(code, style: context.textTheme.titleSmall),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(name, style: context.textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
                  ),
                  if (isSelected) AppSvgIcon(AppIcon.check, size: AppSizes.iconMd, color: colors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
