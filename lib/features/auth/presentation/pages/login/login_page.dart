import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginCubit(getIt<AccountGateway>()), child: const LoginView());
  }
}
