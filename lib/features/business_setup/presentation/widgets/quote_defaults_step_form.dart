import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/currency_field.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/deposit_type_selector.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/deposit_value_field.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_step_heading.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class QuoteDefaultsStepForm extends StatelessWidget {
  const QuoteDefaultsStepForm({super.key});

  static const int _currencyFlex = 3;
  static const int _taxFlex = 2;
  static const int _percentDecimals = 2;
  static const int _noteMinLines = 3;
  static const int _noteMaxLines = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SetupStepHeading(title: l10n.setupQuoteDefaultsTitle, subtitle: l10n.setupQuoteDefaultsSubtitle),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: _currencyFlex, child: CurrencyField()),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: _taxFlex,
              child: SetupTextField(
                field: SetupField.taxRate,
                label: l10n.fieldTaxRate,
                decimals: _percentDecimals,
                suffixText: l10n.unitPercent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppFieldLabel(text: l10n.fieldDefaultDeposit),
        const SizedBox(height: AppSpacing.xs),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: DepositTypeSelector()),
            SizedBox(width: AppSpacing.md),
            Expanded(child: DepositValueField()),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SetupTextField(
          field: SetupField.validityDays,
          label: l10n.fieldQuoteValidity,
          decimals: 0,
          suffixText: l10n.unitDays,
        ),
        const SizedBox(height: AppSpacing.lg),
        SetupTextField(
          field: SetupField.paymentLink,
          label: l10n.fieldPaymentLink,
          hintText: l10n.fieldPaymentLinkHint,
          helperText: l10n.fieldPaymentLinkHelper,
          keyboardType: TextInputType.url,
          suffixIcon: const AppSvgIcon(AppIcon.link),
        ),
        const SizedBox(height: AppSpacing.lg),
        SetupTextField(
          field: SetupField.defaultNote,
          label: l10n.fieldDefaultNote,
          hintText: l10n.fieldDefaultNoteHint,
          textCapitalization: TextCapitalization.sentences,
          minLines: _noteMinLines,
          maxLines: _noteMaxLines,
        ),
      ],
    );
  }
}
