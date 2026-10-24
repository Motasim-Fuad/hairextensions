import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension SetupFieldErrorMessage on SetupFieldError {
  String message(AppLocalizations l10n) {
    return switch (this) {
      SetupFieldError.required => l10n.fieldRequired,
      SetupFieldError.tooLong => l10n.validationTooLong,
      SetupFieldError.invalidEmail => l10n.validationInvalidEmail,
      SetupFieldError.invalidUrl => l10n.validationInvalidUrl,
      SetupFieldError.invalidPhone => l10n.validationInvalidPhone,
      SetupFieldError.invalidPercent => l10n.validationInvalidPercent,
      SetupFieldError.invalidAmount => l10n.validationInvalidAmount,
      SetupFieldError.invalidDays => l10n.validationInvalidDays,
    };
  }
}
