import 'package:intl/intl.dart';

/// Formats minor units (fils, cents) as "AED 2,104.00". Formatters are cached
/// per currency and precision because NumberFormat creation is not free.
abstract final class MoneyFormatter {
  static const int minorPerMajor = 100;
  static final Map<String, NumberFormat> _cache = {};

  static String format(
    int minor,
    String currencyCode, {
    bool showDecimals = true,
  }) {
    final decimals = showDecimals ? 2 : 0;
    final formatter = _cache.putIfAbsent(
      '$currencyCode$decimals',
      () => NumberFormat.currency(
        symbol: '$currencyCode ',
        decimalDigits: decimals,
      ),
    );
    return formatter.format(minor / minorPerMajor);
  }

  /// Amount without a currency, for example "1,120" or "3.50".
  static String plain(int minor, {bool showDecimals = false}) {
    final decimals = showDecimals ? 2 : 0;
    final formatter = _cache.putIfAbsent(
      'plain$decimals',
      () => NumberFormat.decimalPatternDigits(decimalDigits: decimals),
    );
    return formatter.format(minor / minorPerMajor);
  }

  /// Compact form for stat tiles, for example "5.4k".
  static String compact(int minor) {
    return NumberFormat.compact().format(minor / minorPerMajor).toLowerCase();
  }
}
