import 'package:flutter/widgets.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

/// Supported locales come from the ARB files, so adding app_xx.arb is the
/// only step needed to ship a new language.
abstract final class AppLocales {
  static const Locale fallback = Locale('en');
  static const List<Locale> supported = AppLocalizations.supportedLocales;
  static const List<LocalizationsDelegate<dynamic>> delegates = AppLocalizations.localizationsDelegates;
}
