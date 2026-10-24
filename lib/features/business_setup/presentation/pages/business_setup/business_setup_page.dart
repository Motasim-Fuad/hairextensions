import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/business_setup_view.dart';

class BusinessSetupPage extends StatelessWidget {
  const BusinessSetupPage({required this.flow, super.key});

  final SetupFlow flow;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BusinessSetupBloc>()..add(BusinessSetupStarted(flow)),
      child: const BusinessSetupView(),
    );
  }
}
