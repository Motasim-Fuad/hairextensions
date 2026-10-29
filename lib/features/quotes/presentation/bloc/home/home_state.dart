part of 'home_cubit.dart';

final class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.now,
    this.profile,
    this.quotes = const [],
    this.summary,
    this.loadError,
  });

  static const int recentCount = 3;

  final String? loadError;
  final ViewStatus status;
  final DateTime now;
  final BusinessProfile? profile;
  final List<Quote> quotes;
  final QuoteMonthSummary? summary;

  List<Quote> get recent => quotes.take(recentCount).toList();

  Quote? get latest => quotes.firstOrNull;

  String get currency =>
      profile?.currencyCode ??
      quotes.firstOrNull?.currencyCode ??
      QuoteFallbacks.currency;

  HomeState copyWith({
    ViewStatus? status,
    BusinessProfile? profile,
    List<Quote>? quotes,
    QuoteMonthSummary? summary,
    String? loadError,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      now: now,
      profile: profile ?? this.profile,
      quotes: quotes ?? this.quotes,
      summary: summary ?? this.summary,
      loadError: clearError ? null : loadError ?? this.loadError,
    );
  }

  @override
  List<Object?> get props => [status, now, profile, quotes, summary, loadError];
}
