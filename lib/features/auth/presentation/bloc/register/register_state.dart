import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = AuthSubmitStatus.idle,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmError,
    this.termsError,
    this.passwordVisible = false,
    this.termsAccepted = false,
  });

  static const Object _keep = Object();

  final AuthSubmitStatus status;
  final AuthFieldError? nameError;
  final AuthFieldError? emailError;
  final AuthFieldError? passwordError;
  final AuthFieldError? confirmError;
  final AuthFieldError? termsError;
  final bool passwordVisible;
  final bool termsAccepted;

  bool get isSubmitting => status == AuthSubmitStatus.submitting;

  /// Error arguments keep the current value when omitted; pass null to clear.
  RegisterState copyWith({
    AuthSubmitStatus? status,
    Object? nameError = _keep,
    Object? emailError = _keep,
    Object? passwordError = _keep,
    Object? confirmError = _keep,
    Object? termsError = _keep,
    bool? passwordVisible,
    bool? termsAccepted,
  }) {
    return RegisterState(
      status: status ?? this.status,
      nameError: identical(nameError, _keep) ? this.nameError : nameError as AuthFieldError?,
      emailError: identical(emailError, _keep) ? this.emailError : emailError as AuthFieldError?,
      passwordError: identical(passwordError, _keep) ? this.passwordError : passwordError as AuthFieldError?,
      confirmError: identical(confirmError, _keep) ? this.confirmError : confirmError as AuthFieldError?,
      termsError: identical(termsError, _keep) ? this.termsError : termsError as AuthFieldError?,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  @override
  List<Object?> get props => [
    status,
    nameError,
    emailError,
    passwordError,
    confirmError,
    termsError,
    passwordVisible,
    termsAccepted,
  ];
}
