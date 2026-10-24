import 'package:flutter/material.dart';
import 'package:hairextensions/app/shell/shell_tab.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class ShellNavItem extends StatelessWidget {
  const ShellNavItem({required this.tab, required this.isSelected, required this.onTap, super.key});

  final ShellTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isSelected ? colors.primary : colors.textTertiary;
    final label = tab.label(context.l10n);
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        child: SizedBox(
          height: AppSizes.bottomBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSvgIcon(isSelected ? tab.selectedIcon : tab.icon, size: AppSizes.iconLg, color: color),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
