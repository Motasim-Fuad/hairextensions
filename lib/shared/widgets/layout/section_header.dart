import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';

/// "Recent quotes ... See all" style heading.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: context.textTheme.headlineSmall)),
        ),
        if (actionLabel != null) AppLinkButton(label: actionLabel!, onPressed: onAction),
      ],
    );
  }
}
