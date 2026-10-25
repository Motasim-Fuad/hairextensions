import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/forgot_password/forgot_password_view.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(getIt<AccountGateway>()),
      child: const ForgotPasswordView(),
    );
  }
}
