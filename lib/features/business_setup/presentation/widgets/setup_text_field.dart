import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/extensions/setup_field_error_message.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/decimal_text_input_formatter.dart';

part 'setup_text_field_state.dart';

/// A field bound to one [SetupField]. It owns its controller, so typing only
/// rebuilds this field, and only when its own error changes.
class SetupTextField extends StatefulWidget {
  const SetupTextField({
    required this.field,
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.maxLines = 1,
    this.minLines,
    this.prefixText,
    this.suffixText,
    this.suffixIcon,
    this.decimals,
  });

  final SetupField field;
  final String? label;
  final String? hintText;
  final String? helperText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final int maxLines;
  final int? minLines;
  final String? prefixText;
  final String? suffixText;
  final Widget? suffixIcon;

  /// Non-null makes this a numeric field with that many decimal places.
  final int? decimals;

  @override
  State<SetupTextField> createState() => _SetupTextFieldState();
}
