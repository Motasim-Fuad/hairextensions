import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = AuthSubmitStatus.idle,
    this.emailError,
    this.passwordError,
    this.passwordVisible = false,
  });

  final AuthSubmitStatus status;
  final AuthFieldError? emailError;
  final AuthFieldError? passwordError;
  final bool passwordVisible;

  bool get isSubmitting => status == AuthSubmitStatus.submitting;

  @override
  List<Object?> get props => [status, emailError, passwordError, passwordVisible];
}
