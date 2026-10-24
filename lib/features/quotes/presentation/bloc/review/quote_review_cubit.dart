import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/review/review_destination.dart';
import 'package:injectable/injectable.dart';

part 'quote_review_state.dart';

@injectable
class QuoteReviewCubit extends Cubit<QuoteReviewState> {
  QuoteReviewCubit(this._repository, @factoryParam Quote? quote) : super(QuoteReviewState(quote: quote!));

  final QuoteRepository _repository;

  void toggleFormulas() => emit(
    QuoteReviewState(quote: state.quote, showFormulas: !state.showFormulas, failure: state.failure),
  );

  Future<void> save(ReviewDestination destination) async {
    if (state.isSaving) {
      return;
    }
    emit(QuoteReviewState(quote: state.quote, showFormulas: state.showFormulas, savingFor: destination));
    final result = await _repository.save(state.quote);
    if (isClosed) {
      return;
    }
    result.match(
      (failure) => emit(QuoteReviewState(quote: state.quote, showFormulas: state.showFormulas, failure: failure)),
      (saved) => emit(QuoteReviewState(quote: saved, showFormulas: state.showFormulas, savedFor: destination)),
    );
  }
}
