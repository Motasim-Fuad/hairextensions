part of '../business_setup_bloc.dart';

final class BusinessSetupStarted extends BusinessSetupEvent {
  const BusinessSetupStarted(this.flow);

  final SetupFlow flow;

  @override
  List<Object?> get props => [flow];
}
