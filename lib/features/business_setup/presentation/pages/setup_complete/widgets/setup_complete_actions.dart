import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';

class SetupCompleteActions extends StatelessWidget {
  const SetupCompleteActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxFormWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppPrimaryButton(
                  label: l10n.actionCreateFirstQuote,
                  trailingIcon: AppIcon.plus,
                  onPressed: () => context.goNamed(AppRoutes.newQuote),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: AppLinkButton(label: l10n.actionGoHome, onPressed: () => context.goNamed(AppRoutes.home)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
