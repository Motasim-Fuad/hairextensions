import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Round bordered icon button (back, close, search, edit). The visual is small
/// but the tap target is always at least the platform minimum.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
    this.isTinted = false,
    this.dimension = AppSizes.buttonHeightCompact,
    this.iconSize = AppSizes.iconMd,
  });

  final AppIcon icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool isTinted;
  final double dimension;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      icon: AppSvgIcon(icon, size: iconSize),
      style: IconButton.styleFrom(
        backgroundColor: isTinted ? colors.primarySoft : colors.surface,
        foregroundColor: isTinted ? colors.primary : colors.textPrimary,
        side: isTinted ? BorderSide.none : BorderSide(color: colors.border),
        minimumSize: Size.square(dimension),
        fixedSize: Size.square(dimension),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
