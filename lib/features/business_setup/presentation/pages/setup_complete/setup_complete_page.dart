import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/setup_summary/setup_summary_cubit.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/setup_complete_view.dart';

class SetupCompletePage extends StatelessWidget {
  const SetupCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SetupSummaryCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const SetupCompleteView(),
    );
  }
}
