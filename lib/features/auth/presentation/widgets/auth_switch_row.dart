import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';

/// "New here? Create account" and its mirror on the register screen.
class AuthSwitchRow extends StatelessWidget {
  const AuthSwitchRow({required this.prompt, required this.actionLabel, required this.onPressed, super.key});

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        Text(prompt, style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary)),
        AppLinkButton(label: actionLabel, onPressed: onPressed),
      ],
    );
  }
}
