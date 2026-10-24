import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/logo_picker_tile.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_step_heading.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_text_field.dart';

class IdentityStepForm extends StatelessWidget {
  const IdentityStepForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SetupStepHeading(title: l10n.setupIdentityTitle, subtitle: l10n.setupIdentitySubtitle),
          const SizedBox(height: AppSpacing.xxl),
          const LogoPickerTile(),
          const SizedBox(height: AppSpacing.xxl),
          SetupTextField(
            field: SetupField.businessName,
            label: l10n.fieldBusinessName,
            hintText: l10n.fieldBusinessNameHint,
            isRequired: true,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.organizationName],
          ),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(
            field: SetupField.ownerName,
            label: l10n.fieldOwnerName,
            hintText: l10n.fieldOwnerNameHint,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
          ),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(
            field: SetupField.tagline,
            label: l10n.fieldTagline,
            hintText: l10n.fieldTaglineHint,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
