import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/buttons/button_content.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

/// Outlined action, for example "Save" or "Duplicate".
class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.isLoading = false,
    this.errorText,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppIcon? leadingIcon;
  final bool isLoading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IgnorePointer(
          ignoring: isLoading,
          child: OutlinedButton(
            onPressed: onPressed,
            child: ButtonContent(
              label: label,
              isLoading: isLoading,
              foreground: context.colors.primary,
              leadingIcon: leadingIcon,
            ),
          ),
        ),
        InlineErrorText(message: errorText),
      ],
    );
  }
}
