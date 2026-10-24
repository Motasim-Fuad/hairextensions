import 'package:flutter/material.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/decimal_text_input_formatter.dart';

/// Numeric field for money, grams, hours and percentages. Use [prefixText]
/// for a currency code and [suffixText] for a unit.
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    this.label,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.prefixText,
    this.suffixText,
    this.suffixIcon,
    this.decimals = 2,
    this.textInputAction,
    this.onChanged,
  });

  final String? label;
  final bool isRequired;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final String? prefixText;
  final String? suffixText;
  final Widget? suffixIcon;
  final int decimals;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      isRequired: isRequired,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      errorText: errorText,
      prefixText: prefixText == null ? null : '$prefixText ',
      suffixText: suffixText,
      suffixIcon: suffixIcon,
      keyboardType: TextInputType.numberWithOptions(decimal: decimals > 0),
      textInputAction: textInputAction,
      inputFormatters: [DecimalTextInputFormatter(decimals: decimals)],
      onChanged: onChanged,
    );
  }
}
