import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/button_content.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

/// Tinted secondary action, for example "Convert to invoice" or "Clear search".
class AppSoftButton extends StatelessWidget {
  const AppSoftButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.isLoading = false,
    this.isCompact = false,
    this.errorText,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppIcon? leadingIcon;
  final bool isLoading;
  final bool isCompact;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final button = IgnorePointer(
      ignoring: isLoading,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primarySoft,
          foregroundColor: colors.primary,
          minimumSize: isCompact
              ? const Size(0, AppSizes.buttonHeightCompact)
              : const Size.fromHeight(AppSizes.buttonHeight),
          padding: isCompact ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg) : null,
          shape: RoundedRectangleBorder(borderRadius: isCompact ? AppRadius.pillAll : AppRadius.mdAll),
          textStyle: isCompact ? context.textTheme.labelMedium : context.textTheme.labelLarge,
        ),
        child: ButtonContent(label: label, isLoading: isLoading, foreground: colors.primary, leadingIcon: leadingIcon),
      ),
    );
    if (isCompact) {
      return button;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        InlineErrorText(message: errorText),
      ],
    );
  }
}
