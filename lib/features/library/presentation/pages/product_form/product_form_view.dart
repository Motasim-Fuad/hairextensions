import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/amount_parser.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/library/presentation/bloc/product_form/product_form_cubit.dart';
import 'package:hairextensions/features/library/presentation/extensions/hair_type_text.dart';
import 'package:hairextensions/features/library/presentation/pages/library/library_view.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chips.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';
import 'package:hairextensions/shared/widgets/inputs/app_number_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/app_switch_tile.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_confirm_dialog.dart';
import 'package:hairextensions/shared/widgets/layout/app_top_bar.dart';

/// Design 4.3.
class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  late final ProductFormCubit _cubit = context.read<ProductFormCubit>();
  late final TextEditingController _name = TextEditingController(text: _cubit.state.product.name);
  late final TextEditingController _length = TextEditingController(
    text: _cubit.state.product.lengthInches == 0 ? '' : '${_cubit.state.product.lengthInches}',
  );
  late final TextEditingController _colour = TextEditingController(text: _cubit.state.product.colour);
  late final TextEditingController _price = TextEditingController(
    text: AmountParser.fromMinor(_cubit.state.product.packPriceMinor),
  );
  late final TextEditingController _units = TextEditingController(
    text: _cubit.state.product.unitsPerPack == 0 ? '' : '${_cubit.state.product.unitsPerPack}',
  );
  late final TextEditingController _markup = TextEditingController(
    text: PercentFormatter.format(_cubit.state.product.markupPercent),
  );
  late final TextEditingController _retail = TextEditingController(
    text: AmountParser.fromMinor(_cubit.state.product.retailPerUnitMinor),
  );

  @override
  void dispose() {
    for (final controller in [_name, _length, _colour, _price, _units, _markup, _retail]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: AppIcon.trash,
      title: l10n.deleteProductTitle,
      message: l10n.deleteProductMessage(_cubit.state.product.name),
      confirmLabel: l10n.actionDelete,
      cancelLabel: l10n.actionCancel,
    );
    if (confirmed) {
      await _cubit.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    const currency = LibraryView.currency;
    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listenWhen: (previous, current) => !previous.isDone && current.isDone,
      listener: (context, _) => context.canPop() ? context.pop() : context.goNamed(AppRoutes.library),
      builder: (context, state) {
        final product = state.product;
        final isGrams = product.soldBy == SoldBy.grams;
        final unitsPerPack = product.unitsPerPack;
        return Scaffold(
          appBar: AppTopBar(
            leading: const AppBackButton(icon: AppIcon.close),
            title: state.isNew ? l10n.productNewTitle : l10n.productEditTitle,
            trailing: [
              AppLinkButton(label: l10n.actionSave, onPressed: state.isSaving ? null : () => unawaited(_cubit.save())),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxl),
            children: [
              AppTextField(
                label: l10n.productName,
                isRequired: true,
                controller: _name,
                hintText: l10n.sampleProductName,
                textCapitalization: TextCapitalization.words,
                errorText: state.showNameError ? l10n.fieldRequired : null,
                onChanged: (value) => _cubit.update((p) => p.copyWith(name: value)),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(text: l10n.productType),
              const SizedBox(height: AppSpacing.sm),
              AppChoiceChips<HairType>(
                options: [for (final type in HairType.values) SegmentOption(value: type, label: type.label(l10n))],
                selected: product.type,
                onChanged: (type) => _cubit.update((p) => p.copyWith(type: type)),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: AppNumberField(
                      label: l10n.productLength,
                      controller: _length,
                      suffixText: l10n.unitInch,
                      decimals: 0,
                      onChanged: (value) => _cubit.update((p) => p.copyWith(lengthInches: AmountParser.integer(value))),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      label: l10n.productColour,
                      controller: _colour,
                      hintText: l10n.productColourHint,
                      onChanged: (value) => _cubit.update((p) => p.copyWith(colour: value)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(text: l10n.productSoldBy),
              const SizedBox(height: AppSpacing.sm),
              AppSegmentedControl<SoldBy>(
                options: [
                  SegmentOption(value: SoldBy.grams, label: l10n.soldByGrams),
                  SegmentOption(value: SoldBy.pieces, label: l10n.soldByPieces),
                ],
                selected: product.soldBy,
                onChanged: (soldBy) => _cubit.update((p) => p.copyWith(soldBy: soldBy)),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: AppNumberField(
                      label: l10n.labelPackPrice,
                      isRequired: true,
                      controller: _price,
                      prefixText: currency,
                      errorText: state.showPriceError ? l10n.fieldRequired : null,
                      onChanged: (value) =>
                          _cubit.update((p) => p.copyWith(packPriceMinor: AmountParser.toMinor(value))),
                    ),
                  ),
                  Expanded(
                    child: AppNumberField(
                      label: isGrams ? l10n.labelGramsPerPack : l10n.productPiecesPerPack,
                      isRequired: true,
                      controller: _units,
                      suffixText: isGrams ? l10n.unitGramsShort : l10n.unitStrands,
                      decimals: 0,
                      errorText: state.showUnitsError ? l10n.fieldRequired : null,
                      onChanged: (value) => _cubit.update((p) => p.copyWith(unitsPerPack: AmountParser.integer(value))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(color: colors.primarySoft, borderRadius: AppRadius.lgAll),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGrams ? l10n.productCostPerGram : l10n.productCostPerPiece,
                              style: AppTextStyles.overline.copyWith(color: colors.primaryStrong),
                            ),
                            Text(
                              MoneyFormatter.format(product.costPerUnitMinor, currency),
                              style: AppTextStyles.highlightAmount.copyWith(color: colors.primaryStrong),
                            ),
                          ],
                        ),
                      ),
                      if (unitsPerPack > 0)
                        Text(
                          l10n.divisionFormula(MoneyFormatter.plain(product.packPriceMinor), unitsPerPack),
                          style: AppTextStyles.detail.copyWith(color: colors.primaryStrong),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppFieldLabel(text: l10n.productDefaultPricing),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    flex: 2,
                    child: AppSegmentedControl<PricingMode>(
                      options: [
                        SegmentOption(value: PricingMode.markup, label: l10n.pricingMarkup),
                        SegmentOption(value: PricingMode.retail, label: l10n.pricingRetailPerGram),
                      ],
                      selected: product.pricingMode,
                      onChanged: (mode) => _cubit.update((p) => p.copyWith(pricingMode: mode)),
                    ),
                  ),
                  Expanded(
                    child: product.pricingMode == PricingMode.markup
                        ? AppNumberField(
                            controller: _markup,
                            suffixText: l10n.unitPercent,
                            decimals: 1,
                            onChanged: (value) =>
                                _cubit.update((p) => p.copyWith(markupPercent: AmountParser.decimal(value))),
                          )
                        : AppNumberField(
                            controller: _retail,
                            prefixText: currency,
                            onChanged: (value) =>
                                _cubit.update((p) => p.copyWith(retailPerUnitMinor: AmountParser.toMinor(value))),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppSwitchTile(
                title: l10n.productTaxableDefault,
                value: product.isTaxable,
                onChanged: (value) => _cubit.update((p) => p.copyWith(isTaxable: value)),
              ),
              if (state.failure != null) InlineErrorText(message: state.failure!.localizedMessage(l10n)),
              if (!state.isNew) ...[
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: AppLinkButton(
                    label: l10n.actionDeleteProduct,
                    icon: AppIcon.trash,
                    color: colors.danger,
                    onPressed: () => unawaited(_delete()),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
