import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';

/// Pricing rules for each kind of line. Used by the add sheets for the live
/// preview and by the demo seed, so both price identically.
abstract final class QuoteLineFactory {
  static const double _percent = 100;

  /// Whole pack: packs are rounded up and the leftover hair is reported.
  /// Exact grams: cost is grams × cost per gram.
  static QuoteLine hair({
    required String id,
    required Product product,
    required int grams,
    required bool wholePack,
    required PricingMode pricingMode,
    required double markupPercent,
    required int retailPriceMinor,
    required bool isTaxable,
  }) {
    final perPack = product.unitsPerPack;
    final packs = wholePack && perPack > 0 ? (grams / perPack).ceil() : null;
    final cost = packs != null ? packs * product.packPriceMinor : grams * product.costPerUnitMinor;
    final amount = pricingMode == PricingMode.markup
        ? (cost * (1 + markupPercent / _percent)).round()
        : retailPriceMinor;
    return QuoteLine(
      id: id,
      category: LineCategory.hair,
      title: product.name,
      variant: product.colour,
      amountMinor: amount,
      costMinor: cost,
      isTaxable: isTaxable,
      grams: grams,
      packs: packs,
      leftoverGrams: packs == null ? null : packs * perPack - grams,
      markupPercent: pricingMode == PricingMode.markup ? markupPercent : null,
    );
  }

  static QuoteLine service({
    required String id,
    required String title,
    required int rateMinor,
    required double? hours,
    required bool isTaxable,
  }) {
    return QuoteLine(
      id: id,
      category: LineCategory.service,
      title: title,
      amountMinor: hours == null ? rateMinor : (rateMinor * hours).round(),
      isTaxable: isTaxable,
      unitPriceMinor: rateMinor,
      hours: hours,
    );
  }

  static QuoteLine item({
    required String id,
    required LineCategory category,
    required String title,
    required int quantity,
    required int unitPriceMinor,
    required int unitCostMinor,
    required bool isTaxable,
  }) {
    return QuoteLine(
      id: id,
      category: category,
      title: title,
      amountMinor: quantity * unitPriceMinor,
      costMinor: quantity * unitCostMinor,
      isTaxable: isTaxable,
      quantity: quantity,
      unitPriceMinor: unitPriceMinor,
    );
  }

  /// Shipping is passed through at cost, so it adds no profit.
  static QuoteLine shipping({
    required String id,
    required String title,
    required int amountMinor,
    required bool isTaxable,
  }) {
    return QuoteLine(
      id: id,
      category: LineCategory.shipping,
      title: title,
      amountMinor: amountMinor,
      costMinor: amountMinor,
      isTaxable: isTaxable,
    );
  }
}
