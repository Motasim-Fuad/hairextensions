part of 'quote_detail_cubit.dart';

final class QuoteDetailState extends Equatable {
  const QuoteDetailState({required this.status, this.quote, this.isGone = false, this.failure});

  final ViewStatus status;
  final Quote? quote;

  /// The quote was deleted (here or elsewhere); the screen should close.
  final bool isGone;
  final Failure? failure;

  @override
  List<Object?> get props => [status, quote, isGone, failure];
}
