import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/buttons/button_content.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

/// Main call to action. A failed action passes [errorText], which renders
/// directly below the button. Taps are ignored while [isLoading].
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isCompact = false,
    this.errorText,
    this.onRetry,
    this.retryLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppIcon? leadingIcon;
  final AppIcon? trailingIcon;
  final bool isLoading;
  final bool isCompact;
  final String? errorText;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IgnorePointer(
          ignoring: isLoading,
          child: FilledButton(
            onPressed: onPressed,
            style: isCompact
                ? FilledButton.styleFrom(minimumSize: const Size.fromHeight(AppSizes.buttonHeightCompact))
                : null,
            child: ButtonContent(
              label: label,
              isLoading: isLoading,
              foreground: colors.onPrimary,
              leadingIcon: leadingIcon,
              trailingIcon: trailingIcon,
            ),
          ),
        ),
        InlineErrorText(message: errorText, actionLabel: retryLabel, onAction: onRetry),
      ],
    );
  }
}
