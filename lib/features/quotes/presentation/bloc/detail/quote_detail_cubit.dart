import 'package:hairextensions/features/quotes/domain/repositories/quote_server_operations.dart';

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
  QuoteDetailCubit(this._repository)
    : super(const QuoteDetailState(status: ViewStatus.loading));

  final QuoteRepository _repository;
  StreamSubscription<Quote?>? _subscription;
  bool _busy = false;
  String? _id;
  void retry() {
    final id = _id;
    if (id != null) start(id);
  }

  void start(String id) {
    _id = id;
    unawaited(_subscription?.cancel());
    emit(const QuoteDetailState(status: ViewStatus.loading));
    _subscription = _repository
        .watch(id)
        .listen(
          (quote) => emit(
            QuoteDetailState(
              status: ViewStatus.ready,
              quote: quote,
              isGone: quote == null,
            ),
          ),
          onError: (Object error, StackTrace stack) {
            if (!isClosed)
              emit(
                QuoteDetailState(
                  status: ViewStatus.ready,
                  failure: error is Failure ? error : const UnknownFailure(),
                ),
              );
          },
        );
  }

  Future<Quote?> duplicate() async {
    final quote = state.quote;
    final repository = _repository;
    if (quote == null || repository is! QuoteServerOperations) return null;
    final result = await (repository as QuoteServerOperations).duplicate(
      quote.id,
    );
    if (isClosed) return null;
    return result.match((failure) {
      emit(
        QuoteDetailState(
          status: state.status,
          quote: state.quote,
          failure: failure,
        ),
      );
      return null;
    }, (created) => created);
  }

  Future<void> updateStatus(String status) async {
    final repository = _repository;
    if (repository is QuoteServerOperations) {
      await _run(
        (id) => (repository as QuoteServerOperations).updateStatus(id, status),
      );
    }
  }

  Future<void> convertToInvoice() => _run(_repository.convertToInvoice);

  Future<void> markPaid() => _run(_repository.markPaid);

  Future<void> delete() async {
    final quote = state.quote;
    if (quote != null) {
      final result = await _repository.delete(quote.id);
      if (isClosed) return;
      result.match(
        (failure) => emit(
          QuoteDetailState(
            status: state.status,
            quote: quote,
            failure: failure,
          ),
        ),
        (_) => emit(QuoteDetailState(status: ViewStatus.ready, isGone: true)),
      );
    }
  }

  Future<void> _run(
    Future<Either<Failure, Quote>> Function(String id) action,
  ) async {
    final quote = state.quote;
    if (quote == null) {
      return;
    }
    if (_busy) return;
    _busy = true;
    final result = await action(quote.id);
    _busy = false;
    if (isClosed) return;
    result.match(
      (failure) => emit(
        QuoteDetailState(
          status: state.status,
          quote: state.quote,
          failure: failure,
        ),
      ),
      (saved) => emit(QuoteDetailState(status: ViewStatus.ready, quote: saved)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
