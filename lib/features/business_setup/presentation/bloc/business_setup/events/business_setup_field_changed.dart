part of '../business_setup_bloc.dart';

final class BusinessSetupFieldChanged extends BusinessSetupEvent {
  const BusinessSetupFieldChanged(this.field, this.value);

  final SetupField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}
