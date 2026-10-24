import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension AuthFieldErrorMessage on AuthFieldError {
  String message(AppLocalizations l10n) {
    return switch (this) {
      AuthFieldError.required => l10n.fieldRequired,
      AuthFieldError.invalidEmail => l10n.validationInvalidEmail,
      AuthFieldError.passwordTooShort => l10n.authErrorPasswordShort,
      AuthFieldError.passwordTooWeak => l10n.authErrorPasswordWeak,
      AuthFieldError.passwordMismatch => l10n.authErrorPasswordMismatch,
      AuthFieldError.termsNotAccepted => l10n.authErrorTermsRequired,
    };
  }
}
