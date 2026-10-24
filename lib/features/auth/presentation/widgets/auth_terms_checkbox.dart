import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

/// "I agree to the terms" row. The whole row toggles, and the error shows
/// directly below it.
class AuthTermsCheckbox extends StatelessWidget {
  const AuthTermsCheckbox({required this.value, required this.onChanged, super.key, this.errorText});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MergeSemantics(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: AppRadius.smAll,
              onTap: () => onChanged(!value),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
                child: Row(
                  children: [
                    Checkbox(value: value, onChanged: (checked) => onChanged(checked ?? false)),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(context.l10n.authTermsLabel, style: context.textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ),
        ),
        InlineErrorText(message: errorText),
      ],
    );
  }
}
