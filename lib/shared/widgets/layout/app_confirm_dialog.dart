import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/app_danger_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_neutral_button.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

/// Confirmation before a destructive action. Used only to ask, never to
/// report success or errors.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
  });

  final AppIcon icon;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  static Future<bool> show(
    BuildContext context, {
    required AppIcon icon,
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        icon: icon,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xxl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxDialogWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBadge(
                icon: icon,
                size: AppSizes.iconBadgeLarge,
                background: colors.dangerSoft,
                foreground: colors.danger,
              ),
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                header: true,
                child: Text(title, style: context.textTheme.headlineSmall, textAlign: TextAlign.center),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppNeutralButton(label: cancelLabel, onPressed: () => Navigator.of(context).pop(false)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppDangerButton(label: confirmLabel, onPressed: () => Navigator.of(context).pop(true)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
