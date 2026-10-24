import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Password input with a show/hide toggle. Visibility lives in the cubit so a
/// single toggle can drive both password fields on the register screen.
class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.onChanged,
    super.key,
    this.focusNode,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppTextField(
      label: label,
      hintText: hintText,
      controller: controller,
      focusNode: focusNode,
      errorText: errorText,
      obscureText: !isVisible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        tooltip: isVisible ? l10n.authHidePassword : l10n.authShowPassword,
        icon: AppSvgIcon(isVisible ? AppIcon.eyeOff : AppIcon.eye, size: AppSizes.iconMd),
      ),
    );
  }
}
