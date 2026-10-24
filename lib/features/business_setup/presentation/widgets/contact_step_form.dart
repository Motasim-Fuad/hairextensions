import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_step_heading.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_text_field.dart';

class ContactStepForm extends StatelessWidget {
  const ContactStepForm({super.key});

  static const int _addressLines = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SetupStepHeading(title: l10n.setupContactTitle, subtitle: l10n.setupContactSubtitle),
          const SizedBox(height: AppSpacing.xxl),
          SetupTextField(
            field: SetupField.phone,
            label: l10n.fieldPhone,
            hintText: l10n.fieldPhoneHint,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
          ),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(
            field: SetupField.email,
            label: l10n.fieldEmail,
            hintText: l10n.fieldEmailHint,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
          ),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(field: SetupField.instagram, label: l10n.fieldInstagram, hintText: l10n.fieldInstagramHint),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(
            field: SetupField.website,
            label: l10n.fieldWebsite,
            hintText: l10n.fieldWebsiteHint,
            keyboardType: TextInputType.url,
            autofillHints: const [AutofillHints.url],
          ),
          const SizedBox(height: AppSpacing.lg),
          SetupTextField(
            field: SetupField.address,
            label: l10n.fieldAddress,
            hintText: l10n.fieldAddressHint,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.fullStreetAddress],
            maxLines: _addressLines,
          ),
        ],
      ),
    );
  }
}
