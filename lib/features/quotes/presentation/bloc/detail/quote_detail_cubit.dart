import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'quote_detail_state.dart';

@injectable
class QuoteDetailCubit extends Cubit<QuoteDetailState> {
  QuoteDetailCubit(this._repository) : super(const QuoteDetailState(status: ViewStatus.loading));

  final QuoteRepository _repository;
  StreamSubscription<Quote?>? _subscription;

  void start(String id) {
    _subscription = _repository
        .watch(id)
        .listen(
          (quote) => emit(QuoteDetailState(status: ViewStatus.ready, quote: quote, isGone: quote == null)),
        );
  }

  Future<void> convertToInvoice() => _run(_repository.convertToInvoice);

  Future<void> markPaid() => _run(_repository.markPaid);

  Future<void> delete() async {
    final quote = state.quote;
    if (quote != null) {
      await _repository.delete(quote.id);
    }
  }

  Future<void> _run(Future<Either<Failure, Quote>> Function(String id) action) async {
    final quote = state.quote;
    if (quote == null) {
      return;
    }
    final result = await action(quote.id);
    result.match(
      (failure) => emit(QuoteDetailState(status: state.status, quote: state.quote, failure: failure)),
      (_) {},
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
