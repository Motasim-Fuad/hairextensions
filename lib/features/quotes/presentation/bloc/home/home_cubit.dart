import 'package:hairextensions/features/quotes/domain/repositories/quote_server_operations.dart';

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_month_summary.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/features/quotes/presentation/constants/quote_fallbacks.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._quotes, this._profiles, Clock clock)
    : super(HomeState(status: ViewStatus.loading, now: clock.now()));

  final QuoteRepository _quotes;
  final BusinessProfileReader _profiles;
  StreamSubscription<List<Quote>>? _quoteSubscription;
  StreamSubscription<BusinessProfile?>? _profileSubscription;

  void start() {
    _profileSubscription = _profiles.watch().listen(
      (profile) => emit(state.copyWith(profile: profile)),
    );
    _quoteSubscription = _quotes.watchAll().listen((quotes) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          quotes: quotes,
          summary: _quotes is QuoteServerOperations
              ? null
              : QuoteMonthSummary.of(quotes, state.now),
        ),
      );
      unawaited(_refreshDashboard());
    });
  }

  Future<void> retryDashboard() => _refreshDashboard();

  int _dashboardGeneration = 0;
  Future<void> _refreshDashboard() async {
    final repository = _quotes;
    if (repository is! QuoteServerOperations) return;
    final generation = ++_dashboardGeneration;
    final result = await (repository as QuoteServerOperations).dashboard(
      state.now,
    );
    if (isClosed || generation != _dashboardGeneration) return;
    result.match(
      (_) => emit(
        state.copyWith(
          loadError: 'Unable to load your dashboard. Please retry.',
        ),
      ),
      (summary) => emit(state.copyWith(summary: summary, clearError: true)),
    );
  }

  @override
  Future<void> close() async {
    await _quoteSubscription?.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}
