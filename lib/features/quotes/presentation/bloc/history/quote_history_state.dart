part of 'quote_history_cubit.dart';

final class QuoteHistoryState extends Equatable {
  const QuoteHistoryState({
    required this.status,
    required this.now,
    this.quotes = const [],
    this.query = '',
    this.filter = QuoteFilter.all,
  });

  final ViewStatus status;
  final DateTime now;
  final List<Quote> quotes;
  final String query;
  final QuoteFilter filter;

  bool get hasSearch => query.trim().isNotEmpty || filter != QuoteFilter.all;

  List<Quote> get visible {
    final needle = query.trim().toLowerCase();
    return quotes.where((quote) {
      final matchesFilter = switch (filter) {
        QuoteFilter.all => true,
        QuoteFilter.quotes => quote.status == QuoteStatus.quote,
        QuoteFilter.invoices => quote.status.isInvoice,
        QuoteFilter.thisMonth => quote.createdAt.year == now.year && quote.createdAt.month == now.month,
      };
      if (!matchesFilter) {
        return false;
      }
      return needle.isEmpty ||
          quote.clientName.toLowerCase().contains(needle) ||
          quote.number.toLowerCase().contains(needle);
    }).toList();
  }

  QuoteHistoryState copyWith({ViewStatus? status, List<Quote>? quotes, String? query, QuoteFilter? filter}) {
    return QuoteHistoryState(
      status: status ?? this.status,
      now: now,
      quotes: quotes ?? this.quotes,
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, now, quotes, query, filter];
}
