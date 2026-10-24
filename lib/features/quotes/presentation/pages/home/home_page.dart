import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/home/home_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeCubit>()..start(), child: const HomeView());
  }
}
