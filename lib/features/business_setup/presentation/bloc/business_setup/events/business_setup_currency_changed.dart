part of '../business_setup_bloc.dart';

final class BusinessSetupCurrencyChanged extends BusinessSetupEvent {
  const BusinessSetupCurrencyChanged(this.currencyCode);

  final String currencyCode;

  @override
  List<Object?> get props => [currencyCode];
}
