import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_line_factory.dart';
import 'package:injectable/injectable.dart';

part 'add_hair_state.dart';

@injectable
class AddHairCubit extends Cubit<AddHairState> {
  AddHairCubit(this._catalog, this._ids) : super(const AddHairState());

  final CatalogReader _catalog;
  final IdGenerator _ids;

  Future<void> start() async {
    final products = await _catalog.watchProducts().first;
    if (isClosed) {
      return;
    }
    emit(state.copyWith(products: products));
    if (products.isNotEmpty) {
      selectProduct(products.first);
    }
  }

  void selectProduct(Product product) {
    emit(
      state.copyWith(
        product: product,
        pricingMode: product.pricingMode,
        markupPercent: product.markupPercent,
        isTaxable: product.isTaxable,
      ),
    );
  }

  void setWholePack({required bool value}) => emit(state.copyWith(wholePack: value));

  void setGrams(int grams) => emit(state.copyWith(grams: grams));

  void setPricingMode(PricingMode mode) => emit(state.copyWith(pricingMode: mode));

  void setMarkup(double percent) => emit(state.copyWith(markupPercent: percent));

  void setRetail(int minor) => emit(state.copyWith(retailMinor: minor));

  void setTaxable({required bool value}) => emit(state.copyWith(isTaxable: value));

  /// The line to add, or null after flagging missing input inline.
  QuoteLine? submit() {
    final preview = state.preview;
    if (!state.isValid || preview == null) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    return QuoteLine(
      id: _ids.next(),
      category: preview.category,
      title: preview.title,
      variant: preview.variant,
      amountMinor: preview.amountMinor,
      costMinor: preview.costMinor,
      isTaxable: preview.isTaxable,
      grams: preview.grams,
      packs: preview.packs,
      leftoverGrams: preview.leftoverGrams,
      markupPercent: preview.markupPercent,
    );
  }
}
