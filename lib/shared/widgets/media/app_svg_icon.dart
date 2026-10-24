import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';

/// Renders an [AppIcon]. Size and color fall back to the ambient [IconTheme],
/// so icons inside buttons pick up the button's foreground automatically.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(this.icon, {super.key, this.size, this.color, this.semanticLabel});

  final AppIcon icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final dimension = size ?? theme.size ?? AppSizes.iconLg;
    final tint = color ?? theme.color ?? DefaultTextStyle.of(context).style.color;
    return SvgPicture.asset(
      icon.assetPath,
      width: dimension,
      height: dimension,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
