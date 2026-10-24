import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';

/// Field with its label above and its error text directly below. The owner
/// keeps the controller so typing never rebuilds anything above the field.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixText,
    this.prefixIcon,
    this.suffixText,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
  });

  final String? label;
  final bool isRequired;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final String? prefixText;
  final Widget? prefixIcon;
  final String? suffixText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      obscureText: obscureText,
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        errorMaxLines: 2,
        helperText: helperText,
        helperMaxLines: 2,
        prefixText: prefixText,
        prefixStyle: context.textTheme.bodyLarge?.copyWith(color: context.colors.textSecondary),
        prefixIcon: prefixIcon,
        suffixText: suffixText,
        suffixStyle: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary),
        suffixIcon: suffixIcon,
      ),
    );
    final text = label;
    if (text == null) {
      return field;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFieldLabel(text: text, isRequired: isRequired),
        const SizedBox(height: AppSpacing.xs),
        field,
      ],
    );
  }
}
