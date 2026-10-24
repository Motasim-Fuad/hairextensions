import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';

/// Small spinner for in-place waits. Full screens use page shaped skeletons.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = AppSizes.iconLg, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: context.l10n.loadingLabel,
        child: SizedBox.square(
          dimension: size,
          child: CircularProgressIndicator(strokeWidth: AppSizes.progressStroke, color: color),
        ),
      ),
    );
  }
}
