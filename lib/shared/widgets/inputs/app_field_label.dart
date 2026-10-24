import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';

/// Label shown above a field, with an asterisk when the field is required.
class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel({required this.text, super.key, this.isRequired = false});

  static const String _requiredMark = ' *';

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmall?.copyWith(color: context.colors.textPrimary);
    return Text.rich(
      TextSpan(
        text: text,
        children: [
          if (isRequired)
            TextSpan(
              text: _requiredMark,
              style: style?.copyWith(color: context.colors.primary),
            ),
        ],
      ),
      style: style,
    );
  }
}
