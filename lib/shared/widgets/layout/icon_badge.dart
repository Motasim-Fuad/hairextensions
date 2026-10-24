import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Tinted icon container used on list rows, section headers and cards. The
/// glyph is half the badge size, as in the design.
class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.icon,
    super.key,
    this.size = AppSizes.iconBadge,
    this.isCircle = true,
    this.background,
    this.foreground,
  });

  static const double _glyphRatio = 0.5;

  final AppIcon icon;
  final double size;
  final bool isCircle;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background ?? colors.primarySoft,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : AppRadius.mdAll,
        ),
        child: Center(
          child: AppSvgIcon(icon, size: size * _glyphRatio, color: foreground ?? colors.primary),
        ),
      ),
    );
  }
}
