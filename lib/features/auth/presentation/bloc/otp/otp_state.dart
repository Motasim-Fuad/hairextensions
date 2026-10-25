import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';

enum OtpResendStatus { idle, sending, sent, failure }

class OtpState extends Equatable {
  const OtpState({
    this.status = AuthSubmitStatus.idle,
    this.codeError,
    this.resendStatus = OtpResendStatus.idle,
  });

  final AuthSubmitStatus status;
  final AuthFieldError? codeError;
  final OtpResendStatus resendStatus;

  bool get isSubmitting => status == AuthSubmitStatus.submitting;

  bool get isResending => resendStatus == OtpResendStatus.sending;

  @override
  List<Object?> get props => [status, codeError, resendStatus];
}
