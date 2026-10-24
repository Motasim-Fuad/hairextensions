import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_line_factory.dart';
import 'package:hairextensions/features/quotes/presentation/constants/quote_fallbacks.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:injectable/injectable.dart';

part 'quote_builder_state.dart';

/// Draft of a new quote. Nothing is saved until review; the draft is handed
/// to the review screen as a [Quote].
@injectable
class QuoteBuilderCubit extends Cubit<QuoteBuilderState> {
  QuoteBuilderCubit(this._repository, this._profiles, this._ids, Clock clock)
    : super(QuoteBuilderState(status: ViewStatus.loading, id: _ids.next(), createdAt: clock.now()));

  final QuoteRepository _repository;
  final BusinessProfileReader _profiles;
  final IdGenerator _ids;

  /// [template] pre-fills client and lines (duplicate); prices stay frozen.
  Future<void> start({Quote? template}) async {
    final profile = await _profiles.read();
    final quoteNumber = (await _repository.nextNumber(QuoteStatus.quote)).getOrElse((_) => '');
    final invoiceNumber = (await _repository.nextNumber(QuoteStatus.invoice)).getOrElse((_) => '');
    if (isClosed) {
      return;
    }
    final shipping = template?.linesIn(LineCategory.shipping).firstOrNull;
    emit(
      state.copyWith(
        status: ViewStatus.ready,
        quoteNumber: quoteNumber,
        invoiceNumber: invoiceNumber,
        currency: template?.currencyCode ?? profile?.currencyCode,
        vatRatePercent: template?.vatRatePercent ?? profile?.taxRatePercent,
        validityDays: profile?.quoteValidityDays,
        depositType: template == null ? profile?.depositType : DepositType.fixed,
        depositPercent: profile?.depositPercent,
        depositFixedMinor: template?.depositMinor ?? profile?.depositFixedMinor,
        note: template?.note ?? profile?.defaultNote,
        paymentLink: template?.paymentLink ?? profile?.paymentLink,
        clientName: template?.clientName,
        clientPhone: template?.clientPhone,
        lines: [
          for (final line in template?.lines ?? const <QuoteLine>[])
            if (line.category != LineCategory.shipping) line,
        ],
        shippingMinor: shipping?.amountMinor,
        shippingTaxable: shipping?.isTaxable,
      ),
    );
  }

  String newLineId() => _ids.next();

  void setKind(QuoteStatus kind) => emit(state.copyWith(kind: kind));

  void setClientName(String value) => emit(state.copyWith(clientName: value));

  void setClientPhone(String value) => emit(state.copyWith(clientPhone: value));

  void setAppointment(DateTime value) => emit(state.copyWith(appointment: value));

  void addLine(QuoteLine line) => emit(state.copyWith(lines: [...state.lines, line]));

  void removeLine(String id) => emit(state.copyWith(lines: state.lines.where((line) => line.id != id).toList()));

  void setShipping(int minor) => emit(state.copyWith(shippingMinor: minor));

  void setShippingTaxable({required bool value}) => emit(state.copyWith(shippingTaxable: value));

  void setVatRate(double value) => emit(state.copyWith(vatRatePercent: value));

  void setDepositType(DepositType type) => emit(state.copyWith(depositType: type));

  void setDepositPercent(double value) => emit(state.copyWith(depositPercent: value));

  void setDepositFixed(int minor) => emit(state.copyWith(depositFixedMinor: minor));

  void setNote(String value) => emit(state.copyWith(note: value));

  void setPaymentLink(String value) => emit(state.copyWith(paymentLink: value));

  /// Returns the draft when it is complete; otherwise flags the missing
  /// fields inline and returns null.
  Quote? submit() {
    if (state.isClientMissing || !state.hasLines) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    return state.quote;
  }
}
