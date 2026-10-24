import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_filter.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'quote_history_state.dart';

@injectable
class QuoteHistoryCubit extends Cubit<QuoteHistoryState> {
  QuoteHistoryCubit(this._repository, Clock clock)
    : super(QuoteHistoryState(status: ViewStatus.loading, now: clock.now()));

  final QuoteRepository _repository;
  StreamSubscription<List<Quote>>? _subscription;

  void start() {
    _subscription = _repository.watchAll().listen(
      (quotes) => emit(state.copyWith(status: ViewStatus.ready, quotes: quotes)),
    );
  }

  void search(String query) => emit(state.copyWith(query: query));

  void clearSearch() => emit(state.copyWith(query: '', filter: QuoteFilter.all));

  void selectFilter(QuoteFilter filter) => emit(state.copyWith(filter: filter));

  Future<void> delete(String id) => _repository.delete(id);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
