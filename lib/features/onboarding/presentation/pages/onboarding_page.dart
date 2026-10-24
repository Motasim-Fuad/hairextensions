import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/features/onboarding/presentation/pages/onboarding_view.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<OnboardingCubit>(), child: const OnboardingView());
  }
}
