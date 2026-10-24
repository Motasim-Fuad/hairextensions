import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';

/// Every derived figure of a quote, computed in one place so the builder,
/// review, PDF and history always agree.
///
/// Profit = total − VAT − costs. Margin is profit over the pre-VAT total.
class QuoteTotals extends Equatable {
  const QuoteTotals({
    required this.subtotalMinor,
    required this.taxableMinor,
    required this.taxableLineCount,
    required this.vatMinor,
    required this.totalMinor,
    required this.depositMinor,
    required this.balanceMinor,
    required this.costsMinor,
    required this.profitMinor,
    required this.marginPercent,
    required this.hours,
    required this.profitPerHourMinor,
  });

  factory QuoteTotals.of(Quote quote) {
    var subtotal = 0;
    var taxable = 0;
    var taxableCount = 0;
    var costs = 0;
    var hours = 0.0;
    for (final line in quote.lines) {
      subtotal += line.amountMinor;
      costs += line.costMinor;
      hours += line.hours ?? 0;
      if (line.isTaxable) {
        taxable += line.amountMinor;
        taxableCount++;
      }
    }
    final vat = (taxable * quote.vatRatePercent / _percent).round();
    final total = subtotal + vat;
    final deposit = quote.depositMinor.clamp(0, total);
    final net = total - vat;
    final profit = net - costs;
    return QuoteTotals(
      subtotalMinor: subtotal,
      taxableMinor: taxable,
      taxableLineCount: taxableCount,
      vatMinor: vat,
      totalMinor: total,
      depositMinor: deposit,
      balanceMinor: total - deposit,
      costsMinor: costs,
      profitMinor: profit,
      marginPercent: net == 0 ? 0 : profit * _percent / net,
      hours: hours,
      profitPerHourMinor: hours == 0 ? null : (profit / hours).round(),
    );
  }

  static const double _percent = 100;

  final int subtotalMinor;
  final int taxableMinor;
  final int taxableLineCount;
  final int vatMinor;
  final int totalMinor;
  final int depositMinor;
  final int balanceMinor;
  final int costsMinor;
  final int profitMinor;
  final double marginPercent;
  final double hours;
  final int? profitPerHourMinor;

  @override
  List<Object?> get props => [
    subtotalMinor,
    taxableMinor,
    taxableLineCount,
    vatMinor,
    totalMinor,
    depositMinor,
    balanceMinor,
    costsMinor,
    profitMinor,
    marginPercent,
    hours,
    profitPerHourMinor,
  ];
}
