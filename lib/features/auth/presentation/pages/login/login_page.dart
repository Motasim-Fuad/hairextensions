import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/data/services/local_account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(auth): resolve AccountGateway from getIt once the account API exists.
    return BlocProvider(create: (_) => LoginCubit(const LocalAccountGateway()), child: const LoginView());
  }
}
