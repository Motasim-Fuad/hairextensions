import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/shared/widgets/layout/app_bottom_sheet.dart';
import 'package:hairextensions/shared/widgets/layout/app_list_tile.dart';

/// Pops the chosen product.
class ProductPickerSheet extends StatelessWidget {
  const ProductPickerSheet({required this.products, required this.currency, super.key});

  final List<Product> products;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBottomSheet(
      title: l10n.pickProductTitle,
      child: Column(
        children: [
          for (final product in products)
            AppListTile(
              icon: AppIcon.package,
              title: product.name,
              subtitle: [
                product.colour,
                l10n.perUnitPrice(MoneyFormatter.format(product.costPerUnitMinor, currency)),
              ].join(l10n.separatorDot),
              onTap: () => Navigator.of(context).pop(product),
            ),
        ],
      ),
    );
  }
}
