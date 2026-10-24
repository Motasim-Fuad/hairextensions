import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/amount_parser.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/add_hair/add_hair_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/sheets/product_picker_sheet.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/calc_row.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/price_summary_card.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';
import 'package:hairextensions/shared/widgets/inputs/app_number_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/app_switch_tile.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

/// Design 3.3. Pops the priced [QuoteLine].
class AddHairSheet extends StatelessWidget {
  const AddHairSheet({required this.currency, super.key});

  final String currency;

  static Future<QuoteLine?> show(BuildContext context, {required String currency}) {
    return AppBottomSheet.show<QuoteLine>(
      context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = getIt<AddHairCubit>();
          unawaited(cubit.start());
          return cubit;
        },
        child: AddHairSheet(currency: currency),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _AddHairForm(currency: currency);
}

class _AddHairForm extends StatefulWidget {
  const _AddHairForm({required this.currency});

  final String currency;

  @override
  State<_AddHairForm> createState() => _AddHairFormState();
}

class _AddHairFormState extends State<_AddHairForm> {
  final TextEditingController _grams = TextEditingController();
  final TextEditingController _markup = TextEditingController();
  final TextEditingController _retail = TextEditingController();

  @override
  void dispose() {
    _grams.dispose();
    _markup.dispose();
    _retail.dispose();
    super.dispose();
  }

  Future<void> _changeProduct(AddHairState state) async {
    final cubit = context.read<AddHairCubit>();
    final picked = await AppBottomSheet.show<Product>(
      context,
      builder: (_) => ProductPickerSheet(products: state.products, currency: widget.currency),
    );
    if (picked != null) {
      cubit.selectProduct(picked);
      _markup.text = PercentFormatter.format(picked.markupPercent);
    }
  }

  void _submit() {
    final line = context.read<AddHairCubit>().submit();
    if (line != null) {
      Navigator.of(context).pop(line);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = widget.currency;
    String money(int minor, {bool decimals = true}) => MoneyFormatter.format(minor, currency, showDecimals: decimals);
    return BlocConsumer<AddHairCubit, AddHairState>(
      listenWhen: (previous, current) => previous.product == null && current.product != null,
      listener: (_, state) => _markup.text = PercentFormatter.format(state.markupPercent),
      builder: (context, state) {
        final cubit = context.read<AddHairCubit>();
        final product = state.product;
        final preview = state.preview;
        final unitLabel = product?.soldBy == SoldBy.pieces ? l10n.unitStrands : l10n.unitGrams;
        return AppBottomSheet(
          title: l10n.addHairTitle,
          footer: AppPrimaryButton(label: l10n.actionAddToQuote, trailingIcon: AppIcon.plus, onPressed: _submit),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              if (product != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(color: colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      spacing: AppSpacing.md,
                      children: [
                        IconBadge(
                          icon: AppIcon.package,
                          size: AppSizes.iconBadgeLarge,
                          isCircle: false,
                          background: colors.primarySurface,
                          foreground: colors.primary,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.lineTitleWithVariant(product.name, product.colour),
                                style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary),
                              ),
                              Text(
                                l10n.productPackSummary(money(product.packPriceMinor), product.unitsPerPack, unitLabel),
                                style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                              ),
                            ],
                          ),
                        ),
                        AppLinkButton(label: l10n.actionChange, onPressed: () => unawaited(_changeProduct(state))),
                      ],
                    ),
                  ),
                ),
              AppSegmentedControl<bool>(
                options: [
                  SegmentOption(value: true, label: l10n.hairWholePack),
                  SegmentOption(value: false, label: l10n.hairExactGrams),
                ],
                selected: state.wholePack,
                onChanged: (value) => cubit.setWholePack(value: value),
              ),
              AppNumberField(
                label: l10n.hairRequiredAmount,
                controller: _grams,
                hintText: l10n.hairRequiredAmountHint,
                suffixText: unitLabel,
                decimals: 0,
                errorText: state.showGramsError ? l10n.fieldRequired : null,
                onChanged: (value) => cubit.setGrams(AmountParser.integer(value)),
              ),
              if (product != null && preview != null)
                DecoratedBox(
                  decoration: BoxDecoration(color: colors.primarySurface, borderRadius: AppRadius.lgAll),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.hairLiveCalculation,
                                style: AppTextStyles.rowLabel.copyWith(color: colors.textPrimary),
                              ),
                            ),
                            AppStatusChip(label: l10n.chipAuto, tone: StatusTone.primary),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        CalcRow(label: l10n.labelCostPerGram, value: money(product.costPerUnitMinor)),
                        if (preview.packs != null) ...[
                          CalcRow(label: l10n.hairPacksNeeded, value: l10n.packsValue(preview.packs!)),
                          CalcRow(label: l10n.hairLeftover, value: l10n.gramsValue('${preview.leftoverGrams ?? 0}')),
                        ],
                        CalcRow(label: l10n.hairYourCost, value: money(preview.costMinor), isStrong: true),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          preview.packs == null
                              ? l10n.hairExactFormula(state.grams, money(product.costPerUnitMinor))
                              : l10n.hairPackFormula(
                                  state.grams,
                                  product.unitsPerPack,
                                  PercentFormatter.format(state.grams / product.unitsPerPack),
                                  preview.packs!,
                                  money(product.packPriceMinor, decimals: false),
                                ),
                          style: AppTextStyles.caption.copyWith(color: colors.primaryStrong),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                spacing: AppSpacing.md,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: AppSegmentedControl<PricingMode>(
                      options: [
                        SegmentOption(value: PricingMode.markup, label: l10n.pricingMarkup),
                        SegmentOption(value: PricingMode.retail, label: l10n.pricingRetail),
                      ],
                      selected: state.pricingMode,
                      onChanged: cubit.setPricingMode,
                    ),
                  ),
                  Expanded(
                    child: state.pricingMode == PricingMode.markup
                        ? AppNumberField(
                            controller: _markup,
                            suffixText: l10n.unitPercent,
                            decimals: 1,
                            onChanged: (value) => cubit.setMarkup(AmountParser.decimal(value)),
                          )
                        : AppNumberField(
                            controller: _retail,
                            prefixText: currency,
                            onChanged: (value) => cubit.setRetail(AmountParser.toMinor(value)),
                          ),
                  ),
                ],
              ),
              AppSwitchTile(
                title: l10n.lineTaxable,
                value: state.isTaxable,
                onChanged: (value) => cubit.setTaxable(value: value),
              ),
              if (preview != null)
                PriceSummaryCard(
                  label: l10n.labelClientPrice,
                  amount: money(preview.amountMinor),
                  sideLabel: l10n.labelProfit,
                  sideValue: l10n.profitValue(money(preview.profitMinor, decimals: false)),
                ),
            ],
          ),
        );
      },
    );
  }
}
