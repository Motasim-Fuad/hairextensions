import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';

/// Visual of the custom toast. Never shown automatically; call
/// AppToastPresenter.show manually where a toast is really wanted.
class AppToast extends StatelessWidget {
  const AppToast({
    required this.message,
    super.key,
    this.tone = StatusTone.neutral,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final StatusTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, iconColor) = switch (tone) {
      StatusTone.success => (Icons.check_circle_rounded, colors.success),
      StatusTone.danger => (Icons.error_rounded, colors.danger),
      StatusTone.warning || StatusTone.gold => (Icons.warning_rounded, colors.warning),
      StatusTone.primary || StatusTone.neutral => (Icons.info_rounded, colors.primarySoft),
    };
    return Semantics(
      liveRegion: true,
      child: Material(
        color: colors.inverseSurface,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: AppSizes.iconMd, color: iconColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: context.textTheme.bodyMedium?.copyWith(color: colors.onInverseSurface),
                ),
              ),
              if (actionLabel != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(foregroundColor: colors.primarySoft),
                  child: Text(actionLabel!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
