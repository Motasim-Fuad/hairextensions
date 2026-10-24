import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/data/services/local_account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/register/register_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(auth): resolve AccountGateway from getIt once the account API exists.
    return BlocProvider(create: (_) => RegisterCubit(const LocalAccountGateway()), child: const RegisterView());
  }
}
