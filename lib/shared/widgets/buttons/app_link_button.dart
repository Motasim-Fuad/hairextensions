import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Text-only action, for example "Go to home", "See all" or "Restore purchases".
class AppLinkButton extends StatelessWidget {
  const AppLinkButton({required this.label, required this.onPressed, super.key, this.icon, this.color});

  final String label;
  final VoidCallback? onPressed;
  final AppIcon? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.colors.primaryStrong;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: foreground),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppSvgIcon(icon!, size: AppSizes.iconSm, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
