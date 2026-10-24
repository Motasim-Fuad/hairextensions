import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/dashed_border_painter.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class LogoUploadPlaceholder extends StatelessWidget {
  const LogoUploadPlaceholder({required this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: context.l10n.setupLogoTitle,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: CustomPaint(
            painter: DashedBorderPainter(color: colors.primary, radius: AppSizes.logoLarge / 2),
            child: SizedBox.square(
              dimension: AppSizes.logoLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSvgIcon(AppIcon.upload, size: AppSizes.iconMd, color: colors.primary),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    context.l10n.setupLogoPlaceholder,
                    style: context.textTheme.labelSmall?.copyWith(color: colors.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
