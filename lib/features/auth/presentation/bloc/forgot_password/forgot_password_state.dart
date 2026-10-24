import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({this.status = AuthSubmitStatus.idle, this.emailError});

  final AuthSubmitStatus status;
  final AuthFieldError? emailError;

  bool get isSubmitting => status == AuthSubmitStatus.submitting;

  /// The confirmation replaces the form once the link has been requested.
  bool get isSent => status == AuthSubmitStatus.success;

  @override
  List<Object?> get props => [status, emailError];
}
