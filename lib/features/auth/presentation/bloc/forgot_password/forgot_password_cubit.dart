import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/domain/validators/auth_validator.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._gateway) : super(const ForgotPasswordState());

  final AccountGateway _gateway;

  void emailEdited() {
    if (state.emailError == null && state.status != AuthSubmitStatus.failure) {
      return;
    }
    emit(const ForgotPasswordState());
  }

  Future<void> submit({required String email}) async {
    if (state.isSubmitting) {
      return;
    }
    final emailError = AuthValidator.email(email);
    if (emailError != null) {
      emit(ForgotPasswordState(emailError: emailError));
      return;
    }
    emit(const ForgotPasswordState(status: AuthSubmitStatus.submitting));
    var succeeded = false;
    try {
      succeeded = await _gateway.requestPasswordReset(email: email.trim());
    } on Object {
      succeeded = false;
    }
    if (isClosed) {
      return;
    }
    emit(ForgotPasswordState(status: succeeded ? AuthSubmitStatus.success : AuthSubmitStatus.failure));
  }
}
