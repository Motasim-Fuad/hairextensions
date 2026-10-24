import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_segment.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_sort.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'library_state.dart';

@injectable
class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this._repository) : super(const LibraryState());

  final LibraryRepository _repository;
  final List<StreamSubscription<Object>> _subscriptions = [];

  void start() {
    _subscriptions
      ..add(
        _repository.watchProducts().listen(
          (products) => emit(state.copyWith(status: ViewStatus.ready, products: products)),
        ),
      )
      ..add(_repository.watchMaterials().listen((materials) => emit(state.copyWith(materials: materials))))
      ..add(_repository.watchServices().listen((services) => emit(state.copyWith(services: services))));
  }

  void selectSegment(LibrarySegment segment) => emit(state.copyWith(segment: segment));

  void search(String query) => emit(state.copyWith(query: query));

  void toggleSort() {
    emit(state.copyWith(sort: state.sort == LibrarySort.recent ? LibrarySort.name : LibrarySort.recent));
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
