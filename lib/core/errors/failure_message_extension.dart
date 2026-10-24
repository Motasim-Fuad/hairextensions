import 'package:hairextensions/core/errors/failure_code.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension FailureMessageExtension on Failure {
  String localizedMessage(AppLocalizations l10n) {
    final serverMessage = message;
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }
    return switch (code) {
      FailureCode.network => l10n.errorNetwork,
      FailureCode.timeout => l10n.errorTimeout,
      FailureCode.cancelled => l10n.errorCancelled,
      FailureCode.unauthorized => l10n.errorUnauthorized,
      FailureCode.forbidden => l10n.errorForbidden,
      FailureCode.notFound => l10n.errorNotFound,
      FailureCode.validation => l10n.errorValidation,
      FailureCode.server => l10n.errorServer,
      FailureCode.localStorage => l10n.errorLocalStorage,
      FailureCode.permissionDenied => l10n.errorPermissionDenied,
      FailureCode.locationDisabled => l10n.errorLocationDisabled,
      FailureCode.unknown => l10n.errorUnknown,
    };
  }
}
