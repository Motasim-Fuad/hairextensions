import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_line_factory.dart';
import 'package:injectable/injectable.dart';

part 'add_item_state.dart';

/// Materials (picked from the library) and add-on services (free text).
@injectable
class AddItemCubit extends Cubit<AddItemState> {
  AddItemCubit(this._catalog, this._ids, @factoryParam LineCategory? category)
    : super(AddItemState(category: category ?? LineCategory.addOn));

  final CatalogReader _catalog;
  final IdGenerator _ids;

  Future<void> start() async {
    if (state.category != LineCategory.material) {
      return;
    }
    final materials = await _catalog.watchMaterials().first;
    if (!isClosed) {
      emit(state.copyWith(materials: materials));
    }
  }

  void applyMaterial(MaterialItem material) {
    emit(
      state.copyWith(
        materialId: material.id,
        name: material.name,
        unitPriceMinor: material.unitPriceMinor,
        unitCostMinor: material.unitCostMinor,
        isTaxable: material.isTaxable,
      ),
    );
  }

  void setName(String value) => emit(state.copyWith(name: value));

  void setQuantity(int value) => emit(state.copyWith(quantity: value));

  void setUnitPrice(int minor) => emit(state.copyWith(unitPriceMinor: minor));

  void setTaxable({required bool value}) => emit(state.copyWith(isTaxable: value));

  QuoteLine? submit() {
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    return QuoteLineFactory.item(
      id: _ids.next(),
      category: state.category,
      title: state.name.trim(),
      quantity: state.quantity,
      unitPriceMinor: state.unitPriceMinor,
      unitCostMinor: state.unitCostMinor,
      isTaxable: state.isTaxable,
    );
  }
}
