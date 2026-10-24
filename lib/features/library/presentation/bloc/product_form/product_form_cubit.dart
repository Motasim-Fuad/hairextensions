import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

part 'product_form_state.dart';

@injectable
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit(this._repository, this._clock, IdGenerator ids, @factoryParam Product? existing)
    : super(
        ProductFormState(
          isNew: existing == null,
          product:
              existing ??
              Product(
                id: ids.next(),
                name: '',
                type: HairType.tapeIn,
                lengthInches: 0,
                colour: '',
                soldBy: SoldBy.grams,
                packPriceMinor: 0,
                unitsPerPack: 0,
                pricingMode: PricingMode.markup,
                markupPercent: _defaultMarkup,
                retailPerUnitMinor: 0,
                isTaxable: true,
                updatedAt: _clock.now(),
              ),
        ),
      );

  static const double _defaultMarkup = 60;

  final LibraryRepository _repository;
  final Clock _clock;

  void update(Product Function(Product product) change) => emit(state.copyWith(product: change(state.product)));

  Future<void> save() async {
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return;
    }
    emit(state.copyWith(isSaving: true));
    final result = await _repository.saveProduct(state.product.copyWith(updatedAt: _clock.now()));
    if (isClosed) {
      return;
    }
    result.match(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(isSaving: false, isDone: true)),
    );
  }

  Future<void> delete() async {
    final result = await _repository.deleteProduct(state.product.id);
    if (isClosed) {
      return;
    }
    result.match(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) => emit(state.copyWith(isDone: true)),
    );
  }
}
