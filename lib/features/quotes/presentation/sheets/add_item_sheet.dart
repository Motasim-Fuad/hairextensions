import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/utils/amount_parser.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/add_item/add_item_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/price_summary_card.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chip.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';
import 'package:hairextensions/shared/widgets/inputs/app_number_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_switch_tile.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';

/// Material (from the library) or add-on service. Pops the [QuoteLine].
class AddItemSheet extends StatefulWidget {
  const AddItemSheet({required this.currency, super.key});

  final String currency;

  static Future<QuoteLine?> show(BuildContext context, {required LineCategory category, required String currency}) {
    return AppBottomSheet.show<QuoteLine>(
      context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = getIt<AddItemCubit>(param1: category);
          unawaited(cubit.start());
          return cubit;
        },
        child: AddItemSheet(currency: currency),
      ),
    );
  }

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _quantity = TextEditingController(text: '1');
  final TextEditingController _price = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  void _apply(MaterialItem material) {
    context.read<AddItemCubit>().applyMaterial(material);
    _name.text = material.name;
    _price.text = AmountParser.fromMinor(material.unitPriceMinor);
  }

  void _submit() {
    final line = context.read<AddItemCubit>().submit();
    if (line != null) {
      Navigator.of(context).pop(line);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency = widget.currency;
    return BlocBuilder<AddItemCubit, AddItemState>(
      builder: (context, state) {
        final cubit = context.read<AddItemCubit>();
        final isMaterial = state.category == LineCategory.material;
        return AppBottomSheet(
          title: isMaterial ? l10n.addMaterialTitle : l10n.addAddOnTitle,
          footer: AppPrimaryButton(label: l10n.actionAddToQuote, leadingIcon: AppIcon.plus, onPressed: _submit),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              if (state.materials.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    AppFieldLabel(text: l10n.materialFromLibrary),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final material in state.materials)
                          AppChoiceChip(
                            label: material.name,
                            isSelected: material.id == state.materialId,
                            onTap: () => _apply(material),
                          ),
                      ],
                    ),
                  ],
                ),
              AppTextField(
                label: l10n.itemName,
                controller: _name,
                hintText: isMaterial ? l10n.materialNameHint : l10n.addOnNameHint,
                textCapitalization: TextCapitalization.sentences,
                errorText: state.showNameError ? l10n.fieldRequired : null,
                onChanged: cubit.setName,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: AppNumberField(
                      label: l10n.itemQuantity,
                      controller: _quantity,
                      decimals: 0,
                      errorText: state.showQuantityError ? l10n.fieldRequired : null,
                      onChanged: (value) => cubit.setQuantity(AmountParser.integer(value)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AppNumberField(
                      label: l10n.itemUnitPrice,
                      controller: _price,
                      prefixText: currency,
                      onChanged: (value) => cubit.setUnitPrice(AmountParser.toMinor(value)),
                    ),
                  ),
                ],
              ),
              AppSwitchTile(
                title: l10n.lineTaxable,
                value: state.isTaxable,
                onChanged: (value) => cubit.setTaxable(value: value),
              ),
              PriceSummaryCard(
                label: l10n.labelClientPrice,
                amount: MoneyFormatter.format(state.amountMinor, currency),
              ),
            ],
          ),
        );
      },
    );
  }
}
