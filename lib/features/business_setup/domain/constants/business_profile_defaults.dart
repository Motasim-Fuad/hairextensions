import 'package:hairextensions/core/constants/supported_currencies.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';

/// Values pre-filled for a brand new business.
abstract final class BusinessProfileDefaults {
  static const String currencyCode = SupportedCurrencies.fallback;
  static const String taxRate = '5';
  static const DepositType depositType = DepositType.percent;
  static const String depositPercent = '30';
  static const String validityDays = '14';
  static const String quotePrefix = 'Q-';
  static const String invoicePrefix = 'INV-';
  static const int firstDocumentNumber = 1;
}
