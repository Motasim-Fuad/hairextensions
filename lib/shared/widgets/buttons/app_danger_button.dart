import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/shared/widgets/buttons/button_content.dart';

/// Destructive confirmation, used inside confirm dialogs.
class AppDangerButton extends StatelessWidget {
  const AppDangerButton({required this.label, required this.onPressed, super.key, this.isLoading = false});

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IgnorePointer(
      ignoring: isLoading,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(backgroundColor: colors.danger, foregroundColor: colors.onPrimary),
        child: ButtonContent(label: label, isLoading: isLoading, foreground: colors.onPrimary),
      ),
    );
  }
}
