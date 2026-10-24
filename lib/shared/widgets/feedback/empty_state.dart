import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_soft_button.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Empty and no-results states. Provide [actionLabel] for a primary call to
/// action or [secondaryActionLabel] for a small soft action such as clear search.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final AppIcon icon;
  final String title;
  final String message;
  final String? actionLabel;
  final AppIcon? actionIcon;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxFormWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: colors.primarySoft, shape: BoxShape.circle),
                child: SizedBox.square(
                  dimension: AppSizes.emptyStateIcon,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.lgAll),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: AppSvgIcon(icon, size: AppSizes.iconLg, color: colors.primary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Semantics(
                header: true,
                child: Text(title, style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.xl),
                AppPrimaryButton(label: actionLabel!, leadingIcon: actionIcon, onPressed: onAction),
              ],
              if (secondaryActionLabel != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppSoftButton(label: secondaryActionLabel!, onPressed: onSecondaryAction, isCompact: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
