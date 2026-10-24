import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/amount_parser.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/add_service/add_service_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/calc_row.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/price_summary_card.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chip.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';
import 'package:hairextensions/shared/widgets/inputs/app_number_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/app_switch_tile.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';

/// Design 3.4. Pops the priced [QuoteLine].
class AddServiceSheet extends StatefulWidget {
  const AddServiceSheet({required this.currency, super.key});

  final String currency;

  static Future<QuoteLine?> show(BuildContext context, {required String currency}) {
    return AppBottomSheet.show<QuoteLine>(
      context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = getIt<AddServiceCubit>();
          unawaited(cubit.start());
          return cubit;
        },
        child: AddServiceSheet(currency: currency),
      ),
    );
  }

  @override
  State<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<AddServiceSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _hours = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _rate.dispose();
    _hours.dispose();
    super.dispose();
  }

  void _apply(ServiceTemplate template) {
    context.read<AddServiceCubit>().applyTemplate(template);
    _name.text = template.name;
    _rate.text = AmountParser.fromMinor(template.rateMinor);
    _hours.text = template.hours == 0 ? '' : PercentFormatter.format(template.hours);
  }

  void _submit() {
    final line = context.read<AddServiceCubit>().submit();
    if (line != null) {
      Navigator.of(context).pop(line);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = widget.currency;
    return BlocBuilder<AddServiceCubit, AddServiceState>(
      builder: (context, state) {
        final cubit = context.read<AddServiceCubit>();
        final rate = MoneyFormatter.format(state.rateMinor, currency, showDecimals: false);
        return AppBottomSheet(
          title: l10n.addServiceTitle,
          footer: AppPrimaryButton(label: l10n.actionAddToQuote, leadingIcon: AppIcon.plus, onPressed: _submit),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              if (state.templates.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    AppFieldLabel(text: l10n.serviceFromTemplates),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final template in state.templates)
                          AppChoiceChip(
                            label: template.name,
                            isSelected: template.id == state.templateId,
                            onTap: () => _apply(template),
                          ),
                      ],
                    ),
                  ],
                ),
              AppTextField(
                label: l10n.serviceName,
                controller: _name,
                hintText: l10n.serviceNameHint,
                textCapitalization: TextCapitalization.sentences,
                errorText: state.showNameError ? l10n.fieldRequired : null,
                onChanged: cubit.setName,
              ),
              AppSegmentedControl<bool>(
                options: [
                  SegmentOption(value: true, label: l10n.serviceHourly),
                  SegmentOption(value: false, label: l10n.serviceFlat),
                ],
                selected: state.isHourly,
                onChanged: (value) => cubit.setHourly(value: value),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    flex: 3,
                    child: AppNumberField(
                      label: state.isHourly ? l10n.serviceRate : l10n.serviceFee,
                      controller: _rate,
                      prefixText: currency,
                      onChanged: (value) => cubit.setRate(AmountParser.toMinor(value)),
                    ),
                  ),
                  if (state.isHourly)
                    Expanded(
                      flex: 2,
                      child: AppNumberField(
                        label: l10n.serviceBookedHours,
                        controller: _hours,
                        suffixText: l10n.unitHoursShort,
                        decimals: 1,
                        errorText: state.showHoursError ? l10n.fieldRequired : null,
                        onChanged: (value) => cubit.setHours(AmountParser.decimal(value)),
                      ),
                    ),
                ],
              ),
              if (state.isHourly)
                DecoratedBox(
                  decoration: BoxDecoration(color: colors.primarySurface, borderRadius: AppRadius.mdAll),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    child: CalcRow(
                      label: l10n.serviceCalculation,
                      value: l10n.lineHoursRate(PercentFormatter.format(state.hours), rate),
                    ),
                  ),
                ),
              AppSwitchTile(
                title: l10n.lineTaxable,
                subtitle: state.isHourly ? l10n.serviceHoursNote : null,
                value: state.isTaxable,
                onChanged: (value) => cubit.setTaxable(value: value),
              ),
              PriceSummaryCard(
                label: l10n.serviceCharge,
                amount: MoneyFormatter.format(state.chargeMinor, currency),
              ),
              Text(
                l10n.serviceProfitNote,
                style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        );
      },
    );
  }
}
