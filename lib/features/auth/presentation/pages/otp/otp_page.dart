import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/otp/otp_cubit.dart';
import 'package:hairextensions/features/auth/presentation/pages/otp/otp_view.dart';

/// Passed as the route `extra` from the register screen.
class OtpArguments {
  const OtpArguments({required this.email, required this.password});

  final String email;
  final String password;
}

class OtpPage extends StatelessWidget {
  const OtpPage({required this.arguments, super.key});

  final OtpArguments arguments;

  @override
  Widget build(BuildContext context) {
    final gateway = getIt<AccountGateway>();
    // Only the local backend returns the code; otherwise it arrives by e-mail.
    final suggestedCode = gateway.takePendingOtp(arguments.email);
    return BlocProvider(
      create: (_) => OtpCubit(gateway, email: arguments.email, password: arguments.password),
      child: OtpView(email: arguments.email, suggestedCode: suggestedCode),
    );
  }
}
