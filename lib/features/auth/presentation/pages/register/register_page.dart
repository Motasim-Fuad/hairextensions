import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/register/register_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => RegisterCubit(getIt<AccountGateway>()), child: const RegisterView());
  }
}
