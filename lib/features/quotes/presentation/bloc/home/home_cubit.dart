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
  HomeCubit(this._quotes, this._profiles, Clock clock) : super(HomeState(status: ViewStatus.loading, now: clock.now()));

  final QuoteRepository _quotes;
  final BusinessProfileReader _profiles;
  StreamSubscription<List<Quote>>? _quoteSubscription;
  StreamSubscription<BusinessProfile?>? _profileSubscription;

  void start() {
    _profileSubscription = _profiles.watch().listen((profile) => emit(state.copyWith(profile: profile)));
    _quoteSubscription = _quotes.watchAll().listen(
      (quotes) => emit(
        state.copyWith(
          status: ViewStatus.ready,
          quotes: quotes,
          summary: QuoteMonthSummary.of(quotes, state.now),
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _quoteSubscription?.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}
