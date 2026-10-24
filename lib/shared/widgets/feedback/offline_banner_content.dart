import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

class OfflineBannerContent extends StatelessWidget {
  const OfflineBannerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: colors.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(Icons.cloud_off_rounded, size: AppSizes.iconSm, color: colors.onInverseSurface),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.offlineBannerMessage,
                  style: context.textTheme.bodySmall?.copyWith(color: colors.onInverseSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
