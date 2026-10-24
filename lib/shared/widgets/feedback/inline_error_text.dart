import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// The only way errors are shown: as text directly below the related button
/// or field. Collapses to nothing when [message] is null.
class InlineErrorText extends StatelessWidget {
  const InlineErrorText({required this.message, super.key, this.actionLabel, this.onAction});

  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return AnimatedSize(
      duration: context.motion(AppMotion.fast),
      alignment: Alignment.topCenter,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Semantics(
                liveRegion: true,
                child: Row(
                  children: [
                    AppSvgIcon(AppIcon.alert, size: AppSizes.iconSm, color: context.colors.danger),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(text, style: context.textTheme.bodySmall?.copyWith(color: context.colors.danger)),
                    ),
                    if (actionLabel != null && onAction != null)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.iconLg),
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        child: Text(actionLabel!),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
