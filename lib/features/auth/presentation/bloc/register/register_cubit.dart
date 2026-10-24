import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/domain/validators/auth_validator.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_state.dart';

enum RegisterField { name, email, password, confirm }

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._gateway) : super(const RegisterState());

  final AccountGateway _gateway;

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void setTermsAccepted({required bool accepted}) {
    emit(state.copyWith(termsAccepted: accepted, termsError: null));
  }

  /// Editing a field clears its own error and any earlier failure message.
  /// Changing the password also clears the mismatch on the confirmation.
  void fieldEdited(RegisterField field) {
    final next = switch (field) {
      RegisterField.name => state.copyWith(status: AuthSubmitStatus.idle, nameError: null),
      RegisterField.email => state.copyWith(status: AuthSubmitStatus.idle, emailError: null),
      RegisterField.password => state.copyWith(
        status: AuthSubmitStatus.idle,
        passwordError: null,
        confirmError: null,
      ),
      RegisterField.confirm => state.copyWith(status: AuthSubmitStatus.idle, confirmError: null),
    };
    if (next != state) {
      emit(next);
    }
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (state.isSubmitting) {
      return;
    }
    final nameError = AuthValidator.name(name);
    final emailError = AuthValidator.email(email);
    final passwordError = AuthValidator.newPassword(password);
    final confirmError = AuthValidator.confirmPassword(password, confirmPassword);
    final termsError = AuthValidator.terms(accepted: state.termsAccepted);
    final hasErrors = [nameError, emailError, passwordError, confirmError, termsError].any((e) => e != null);
    if (hasErrors) {
      emit(
        state.copyWith(
          status: AuthSubmitStatus.idle,
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmError: confirmError,
          termsError: termsError,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: AuthSubmitStatus.submitting,
        nameError: null,
        emailError: null,
        passwordError: null,
        confirmError: null,
        termsError: null,
      ),
    );
    var succeeded = false;
    try {
      succeeded = await _gateway.register(name: name.trim(), email: email.trim(), password: password);
    } on Object {
      succeeded = false;
    }
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: succeeded ? AuthSubmitStatus.success : AuthSubmitStatus.failure));
  }
}
