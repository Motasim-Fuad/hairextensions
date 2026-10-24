import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_line_factory.dart';
import 'package:injectable/injectable.dart';

part 'add_service_state.dart';

@injectable
class AddServiceCubit extends Cubit<AddServiceState> {
  AddServiceCubit(this._catalog, this._ids) : super(const AddServiceState());

  final CatalogReader _catalog;
  final IdGenerator _ids;

  Future<void> start() async {
    final templates = await _catalog.watchServices().first;
    if (!isClosed) {
      emit(state.copyWith(templates: templates));
    }
  }

  void applyTemplate(ServiceTemplate template) {
    emit(
      state.copyWith(
        templateId: template.id,
        name: template.name,
        isHourly: template.isHourly,
        rateMinor: template.rateMinor,
        hours: template.hours,
        isTaxable: template.isTaxable,
      ),
    );
  }

  void setName(String value) => emit(state.copyWith(name: value));

  void setHourly({required bool value}) => emit(state.copyWith(isHourly: value));

  void setRate(int minor) => emit(state.copyWith(rateMinor: minor));

  void setHours(double value) => emit(state.copyWith(hours: value));

  void setTaxable({required bool value}) => emit(state.copyWith(isTaxable: value));

  QuoteLine? submit() {
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    return QuoteLineFactory.service(
      id: _ids.next(),
      title: state.name.trim(),
      rateMinor: state.rateMinor,
      hours: state.isHourly ? state.hours : null,
      isTaxable: state.isTaxable,
    );
  }
}
