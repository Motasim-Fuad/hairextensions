import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/otp/otp_state.dart';

/// Confirms the emailed code, then signs in with the password from the
/// register form, because the API only issues a token at login.
class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._gateway, {required this.email, required this.password}) : super(const OtpState());

  final AccountGateway _gateway;
  final String email;
  final String password;
  bool _verified = false;

  void codeEdited() {
    if (state.codeError == null && state.status != AuthSubmitStatus.failure) {
      return;
    }
    emit(OtpState(resendStatus: state.resendStatus));
  }

  Future<void> submit(String code) async {
    if (state.isSubmitting) {
      return;
    }
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      emit(OtpState(codeError: AuthFieldError.required, resendStatus: state.resendStatus));
      return;
    }
    emit(const OtpState(status: AuthSubmitStatus.submitting));
    var succeeded = false;
    try {
      // A retry after a failed login must not verify twice: the API answers
      // 409 for an already verified account.
      _verified = _verified || await _gateway.verifyOtp(email: email, otp: trimmed);
      succeeded = _verified && await _gateway.logIn(email: email, password: password);
    } on Object {
      succeeded = false;
    }
    if (isClosed) {
      return;
    }
    emit(OtpState(status: succeeded ? AuthSubmitStatus.success : AuthSubmitStatus.failure));
  }

  Future<void> resend() async {
    if (state.isResending) {
      return;
    }
    emit(OtpState(resendStatus: OtpResendStatus.sending, status: state.status, codeError: state.codeError));
    var sent = false;
    try {
      sent = await _gateway.resendOtp(email: email);
    } on Object {
      sent = false;
    }
    if (isClosed) {
      return;
    }
    emit(OtpState(resendStatus: sent ? OtpResendStatus.sent : OtpResendStatus.failure));
  }
}
