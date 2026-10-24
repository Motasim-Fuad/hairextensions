part of 'quote_review_cubit.dart';

final class QuoteReviewState extends Equatable {
  const QuoteReviewState({
    required this.quote,
    this.showFormulas = false,
    this.savingFor,
    this.savedFor,
    this.failure,
  });

  final Quote quote;
  final bool showFormulas;

  /// Destination of the save in progress, so only that button spins.
  final ReviewDestination? savingFor;
  final ReviewDestination? savedFor;
  final Failure? failure;

  bool get isSaving => savingFor != null;

  @override
  List<Object?> get props => [quote, showFormulas, savingFor, savedFor, failure];
}
