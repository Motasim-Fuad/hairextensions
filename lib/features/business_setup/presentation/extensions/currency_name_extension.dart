import 'package:hairextensions/core/constants/supported_currencies.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension CurrencyNameExtension on AppLocalizations {
  String currencyName(String code) {
    return switch (code) {
      SupportedCurrencies.aed => currencyNameAed,
      SupportedCurrencies.sar => currencyNameSar,
      SupportedCurrencies.qar => currencyNameQar,
      SupportedCurrencies.usd => currencyNameUsd,
      SupportedCurrencies.gbp => currencyNameGbp,
      SupportedCurrencies.eur => currencyNameEur,
      SupportedCurrencies.cad => currencyNameCad,
      SupportedCurrencies.aud => currencyNameAud,
      SupportedCurrencies.inr => currencyNameInr,
      SupportedCurrencies.bdt => currencyNameBdt,
      _ => code,
    };
  }

  String currencyLabelFor(String code) => currencyLabel(code, currencyName(code));
}
