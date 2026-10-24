import 'package:flutter/widgets.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension L10nContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
