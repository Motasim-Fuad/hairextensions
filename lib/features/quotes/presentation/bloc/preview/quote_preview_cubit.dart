import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_document_sharer.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/preview/document_mode.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'quote_preview_state.dart';

@injectable
class QuotePreviewCubit extends Cubit<QuotePreviewState> {
  QuotePreviewCubit(this._repository, this._profiles, this._sharer)
    : super(const QuotePreviewState(status: ViewStatus.loading));

  final QuoteRepository _repository;
  final BusinessProfileReader _profiles;
  final QuoteDocumentSharer _sharer;
  StreamSubscription<Quote?>? _subscription;
  String? _id;
  Future<void> retry() async {
    final id = _id;
    if (id != null) await start(id);
  }

  Future<void> start(String id) async {
    _id = id;
    await _subscription?.cancel();
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    final profile = await _profiles.read();
    if (isClosed) {
      return;
    }
    emit(state.copyWith(profile: profile));
    _subscription = _repository
        .watch(id)
        .listen(
          (quote) {
            if (quote != null) {
              emit(state.copyWith(status: ViewStatus.ready, quote: quote));
            }
          },
          onError: (Object error, StackTrace stack) {
            if (!isClosed)
              emit(
                state.copyWith(
                  status: ViewStatus.ready,
                  failure: error is Failure ? error : const UnknownFailure(),
                ),
              );
          },
        );
  }

  void selectMode(DocumentMode mode) =>
      emit(state.copyWith(mode: mode, clearFailure: true));

  Future<void> share(QuoteDocument document) async {
    final quote = state.quote;
    if (quote == null || state.isSharing) {
      return;
    }
    emit(state.copyWith(isSharing: true, clearFailure: true));
    final result = await _sharer.share(document);
    if (isClosed) {
      return;
    }
    await result.match(
      (failure) async =>
          emit(state.copyWith(isSharing: false, failure: failure)),
      (_) async {
        emit(state.copyWith(isSharing: false));
        if (state.mode == DocumentMode.client) {
          await _repository.recordShare(quote.id);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
