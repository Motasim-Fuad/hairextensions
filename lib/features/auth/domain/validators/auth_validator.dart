import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';

/// Client-side checks for the login, registration and reset forms. The server
/// stays the source of truth; these only catch typos before a round trip.
abstract final class AuthValidator {
  static const int minPasswordLength = 8;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final RegExp _letter = RegExp('[A-Za-z]');
  static final RegExp _digit = RegExp('[0-9]');

  static AuthFieldError? name(String value) {
    return value.trim().isEmpty ? AuthFieldError.required : null;
  }

  static AuthFieldError? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return AuthFieldError.required;
    }
    return _email.hasMatch(trimmed) ? null : AuthFieldError.invalidEmail;
  }

  /// Login only checks presence: an existing account may predate today's
  /// password rules.
  static AuthFieldError? existingPassword(String value) {
    return value.isEmpty ? AuthFieldError.required : null;
  }

  static AuthFieldError? newPassword(String value) {
    if (value.isEmpty) {
      return AuthFieldError.required;
    }
    if (value.length < minPasswordLength) {
      return AuthFieldError.passwordTooShort;
    }
    final hasBoth = _letter.hasMatch(value) && _digit.hasMatch(value);
    return hasBoth ? null : AuthFieldError.passwordTooWeak;
  }

  static AuthFieldError? confirmPassword(String password, String confirmation) {
    if (confirmation.isEmpty) {
      return AuthFieldError.required;
    }
    return password == confirmation ? null : AuthFieldError.passwordMismatch;
  }

  static AuthFieldError? terms({required bool accepted}) {
    return accepted ? null : AuthFieldError.termsNotAccepted;
  }
}
