import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';

/// One priced line. Amounts are frozen when the line is added, so later
/// library price changes never rewrite a saved quote.
class QuoteLine extends Equatable {
  const QuoteLine({
    required this.id,
    required this.category,
    required this.title,
    required this.amountMinor,
    this.costMinor = 0,
    this.isTaxable = true,
    this.variant,
    this.quantity = 1,
    this.unitPriceMinor = 0,
    this.hours,
    this.grams,
    this.packs,
    this.leftoverGrams,
    this.markupPercent,
  });

  final String id;
  final LineCategory category;
  final String title;
  final String? variant;
  final int amountMinor;
  final int costMinor;
  final bool isTaxable;
  final int quantity;
  final int unitPriceMinor;

  /// Booked hours for hourly services; null for flat fees.
  final double? hours;
  final int? grams;

  /// Whole packs used; null when priced by exact grams.
  final int? packs;
  final int? leftoverGrams;
  final double? markupPercent;

  int get profitMinor => amountMinor - costMinor;

  @override
  List<Object?> get props => [
    id,
    category,
    title,
    variant,
    amountMinor,
    costMinor,
    isTaxable,
    quantity,
    unitPriceMinor,
    hours,
    grams,
    packs,
    leftoverGrams,
    markupPercent,
  ];
}
