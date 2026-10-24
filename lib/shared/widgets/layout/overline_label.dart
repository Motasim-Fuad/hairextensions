import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';

/// Small uppercase group label such as BUSINESS or CLIENT BREAKDOWN.
class OverlineLabel extends StatelessWidget {
  const OverlineLabel({required this.text, super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(text.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: color)),
    );
  }
}
