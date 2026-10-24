import 'package:flutter/material.dart';
import 'package:hairextensions/core/constants/supported_currencies.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/features/business_setup/presentation/extensions/currency_name_extension.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/currency_option_tile.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';

/// Returns the chosen code, or null when dismissed.
class CurrencyPickerSheet extends StatelessWidget {
  const CurrencyPickerSheet({required this.selected, super.key});

  final String selected;

  static Future<String?> show(BuildContext context, {required String selected}) {
    return AppBottomSheet.show<String>(context, builder: (_) => CurrencyPickerSheet(selected: selected));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBottomSheet(
      title: l10n.currencyPickerTitle,
      child: Column(
        children: [
          for (final code in SupportedCurrencies.codes)
            CurrencyOptionTile(
              code: code,
              name: l10n.currencyName(code),
              isSelected: code == selected,
              onTap: () => Navigator.of(context).pop(code),
            ),
        ],
      ),
    );
  }
}
