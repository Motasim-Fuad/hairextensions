import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/data/services/local_account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/forgot_password/forgot_password_view.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(auth): resolve AccountGateway from getIt once the account API exists.
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(const LocalAccountGateway()),
      child: const ForgotPasswordView(),
    );
  }
}
