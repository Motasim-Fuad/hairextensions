import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:hairextensions/features/settings/presentation/pages/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<SettingsCubit>()..start(), child: const SettingsView());
  }
}
