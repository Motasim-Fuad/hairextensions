import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';

/// Home dashboard figures for one calendar month.
class QuoteMonthSummary extends Equatable {
  const QuoteMonthSummary({
    required this.month,
    required this.quotedMinor,
    required this.quoteCount,
    required this.invoiceCount,
    required this.depositsMinor,
    this.profitPerHourMinor,
    this.changePercent,
    this.previousMonth,
  });

  factory QuoteMonthSummary.of(List<Quote> quotes, DateTime now) {
    final month = DateTime(now.year, now.month);
    final previous = DateTime(now.year, now.month - 1);
    final current = quotes.where((quote) => _isIn(quote.createdAt, month)).toList();
    final before = quotes.where((quote) => _isIn(quote.createdAt, previous));
    var quoted = 0;
    var deposits = 0;
    var profit = 0;
    var hours = 0.0;
    for (final quote in current) {
      final totals = quote.totals;
      quoted += totals.totalMinor;
      deposits += totals.depositMinor;
      profit += totals.profitMinor;
      hours += totals.hours;
    }
    final previousQuoted = before.fold(0, (sum, quote) => sum + quote.totals.totalMinor);
    return QuoteMonthSummary(
      month: month,
      previousMonth: previous,
      quotedMinor: quoted,
      quoteCount: current.where((quote) => quote.status == QuoteStatus.quote).length,
      invoiceCount: current.where((quote) => quote.status.isInvoice).length,
      depositsMinor: deposits,
      profitPerHourMinor: hours == 0 ? null : (profit / hours).round(),
      changePercent: previousQuoted == 0 ? null : ((quoted - previousQuoted) * _percent / previousQuoted).round(),
    );
  }

  static const int _percent = 100;

  final DateTime month;
  final DateTime? previousMonth;
  final int quotedMinor;
  final int quoteCount;
  final int invoiceCount;
  final int depositsMinor;
  final int? profitPerHourMinor;
  final int? changePercent;

  static bool _isIn(DateTime value, DateTime month) => value.year == month.year && value.month == month.month;

  @override
  List<Object?> get props => [
    month,
    previousMonth,
    quotedMinor,
    quoteCount,
    invoiceCount,
    depositsMinor,
    profitPerHourMinor,
    changePercent,
  ];
}
