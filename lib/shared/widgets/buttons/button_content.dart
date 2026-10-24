import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/feedback/app_loader.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Label with optional icons, swapped for a spinner while loading. Shared by
/// every button style so they all behave the same.
class ButtonContent extends StatelessWidget {
  const ButtonContent({
    required this.label,
    required this.isLoading,
    required this.foreground,
    super.key,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final bool isLoading;
  final Color foreground;
  final AppIcon? leadingIcon;
  final AppIcon? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: context.motion(AppMotion.fast),
      child: isLoading
          ? AppLoader(size: AppSizes.iconMd, color: foreground)
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  AppSvgIcon(leadingIcon!, size: AppSizes.iconMd, color: foreground),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                if (trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppSvgIcon(trailingIcon!, size: AppSizes.iconMd, color: foreground),
                ],
              ],
            ),
    );
  }
}
