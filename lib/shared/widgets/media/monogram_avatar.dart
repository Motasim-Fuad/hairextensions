import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_typography.dart';

/// Dark rounded square with initials, the fallback business mark ("GS").
class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({required this.name, super.key, this.size = AppSizes.logo});

  static const int _maxInitials = 2;
  static const double _fontRatio = 0.38;
  static const double _radiusRatio = 0.28;

  final String name;
  final double size;

  static String initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    return words.take(_maxInitials).map((word) => word.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.inverseSurface,
            borderRadius: BorderRadius.circular(size * _radiusRatio),
          ),
          child: Center(
            child: Text(
              initialsOf(name),
              style: TextStyle(
                fontFamily: AppTypography.displayFamily,
                fontSize: size * _fontRatio,
                color: colors.onInverseSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
