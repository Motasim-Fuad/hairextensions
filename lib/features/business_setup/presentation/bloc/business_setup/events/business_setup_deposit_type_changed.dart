part of '../business_setup_bloc.dart';

final class BusinessSetupDepositTypeChanged extends BusinessSetupEvent {
  const BusinessSetupDepositTypeChanged(this.depositType);

  final DepositType depositType;

  @override
  List<Object?> get props => [depositType];
}
