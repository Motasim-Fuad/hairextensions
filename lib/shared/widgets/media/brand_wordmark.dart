import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// The Amna Sheen wordmark in the brand signature font (see
/// AppTypography.logoFamily for how the font file is added).
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final name = context.l10n.brandWordmark;
    return Semantics(
      label: name,
      excludeSemantics: true,
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: AppTextStyles.logoWordmark.copyWith(
          fontSize: size,
          color: color ?? context.colors.primary,
        ),
      ),
    );
  }
}
