import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';

/// Muted grey action, for example "Cancel" in a dialog.
class AppNeutralButton extends StatelessWidget {
  const AppNeutralButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(backgroundColor: colors.surfaceMuted, foregroundColor: colors.textPrimary),
      child: Text(label),
    );
  }
}
