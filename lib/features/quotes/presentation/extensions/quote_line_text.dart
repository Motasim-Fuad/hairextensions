import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

/// Wording for a line in the builder, review and documents.
extension QuoteLineText on QuoteLine {
  String displayTitle(AppLocalizations l10n) {
    if (category == LineCategory.shipping) {
      return l10n.sectionShipping;
    }
    final colour = variant;
    return colour == null || colour.isEmpty ? title : l10n.lineTitleWithVariant(title, colour);
  }

  /// Builder detail, for example "170 g · Whole pack · 2 packs (30 g left)".
  String detail(AppLocalizations l10n, String currency) {
    return switch (category) {
      LineCategory.hair => _hairDetail(l10n),
      LineCategory.service => _serviceDetail(l10n, currency, perHour: true),
      LineCategory.material => l10n.lineQuantityTimes(
        quantity,
        MoneyFormatter.format(unitPriceMinor, currency, showDecimals: false),
      ),
      LineCategory.addOn => l10n.lineFlatFee,
      LineCategory.shipping => isTaxable ? l10n.lineTaxable : l10n.lineNotTaxable,
    };
  }

  /// Short detail for the review breakdown, for example "170 g · 2 packs".
  String shortDetail(AppLocalizations l10n) {
    return switch (category) {
      LineCategory.hair => packs == null ? l10n.gramsValue('${grams ?? 0}') : l10n.lineHairShort(grams ?? 0, packs!),
      LineCategory.service => _serviceDetail(l10n, null, perHour: false),
      LineCategory.material => l10n.lineQuantityTimes(quantity, MoneyFormatter.plain(unitPriceMinor)),
      LineCategory.addOn => l10n.lineAddOn,
      LineCategory.shipping => isTaxable ? l10n.lineTaxable : l10n.lineNotTaxable,
    };
  }

  /// Cost and tax note under a builder line, for example
  /// "Cost AED 700 · Markup 60% · Taxable".
  String meta(AppLocalizations l10n, String currency) {
    final parts = <String>[
      if (costMinor > 0 && category != LineCategory.shipping)
        l10n.lineCost(MoneyFormatter.format(costMinor, currency, showDecimals: false)),
      if (markupPercent != null) l10n.lineMarkup(PercentFormatter.format(markupPercent!)),
      if (isTaxable) l10n.lineTaxable else l10n.lineNotTaxable,
    ];
    return parts.join(l10n.separatorDot);
  }

  String _hairDetail(AppLocalizations l10n) {
    final weight = l10n.gramsValue('${grams ?? 0}');
    if (packs == null) {
      return l10n.lineHairExact(weight);
    }
    return l10n.lineHairWholePack(weight, packs!, leftoverGrams ?? 0);
  }

  String _serviceDetail(AppLocalizations l10n, String? currency, {required bool perHour}) {
    final rate = currency == null
        ? MoneyFormatter.plain(unitPriceMinor)
        : MoneyFormatter.format(unitPriceMinor, currency, showDecimals: false);
    final booked = hours;
    if (booked == null) {
      return l10n.lineFlatFee;
    }
    final value = PercentFormatter.format(booked);
    return perHour ? l10n.lineHoursRatePerHour(value, rate) : l10n.lineHoursRate(value, rate);
  }
}
