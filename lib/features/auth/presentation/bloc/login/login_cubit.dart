import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/domain/validators/auth_validator.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._gateway) : super(const LoginState());

  final AccountGateway _gateway;

  void togglePasswordVisibility() {
    emit(
      LoginState(
        status: state.status,
        emailError: state.emailError,
        passwordError: state.passwordError,
        passwordVisible: !state.passwordVisible,
      ),
    );
  }

  /// Editing a field clears its own error and any earlier failure message.
  void emailEdited() {
    if (state.emailError == null && state.status != AuthSubmitStatus.failure) {
      return;
    }
    emit(LoginState(passwordError: state.passwordError, passwordVisible: state.passwordVisible));
  }

  void passwordEdited() {
    if (state.passwordError == null && state.status != AuthSubmitStatus.failure) {
      return;
    }
    emit(LoginState(emailError: state.emailError, passwordVisible: state.passwordVisible));
  }

  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) {
      return;
    }
    final emailError = AuthValidator.email(email);
    final passwordError = AuthValidator.existingPassword(password);
    if (emailError != null || passwordError != null) {
      emit(
        LoginState(
          emailError: emailError,
          passwordError: passwordError,
          passwordVisible: state.passwordVisible,
        ),
      );
      return;
    }
    emit(LoginState(status: AuthSubmitStatus.submitting, passwordVisible: state.passwordVisible));
    var succeeded = false;
    try {
      succeeded = await _gateway.logIn(email: email.trim(), password: password);
    } on Object {
      succeeded = false;
    }
    if (isClosed) {
      return;
    }
    emit(
      LoginState(
        status: succeeded ? AuthSubmitStatus.success : AuthSubmitStatus.failure,
        passwordVisible: state.passwordVisible,
      ),
    );
  }
}
