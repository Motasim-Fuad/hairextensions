import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';

/// Large serif title at the top of tab pages (Quotes, Library, Settings).
class AppLargeTitle extends StatelessWidget {
  const AppLargeTitle({required this.title, super.key, this.trailing = const []});

  final String title;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: context.textTheme.displaySmall)),
        ),
        ...trailing,
      ],
    );
  }
}
