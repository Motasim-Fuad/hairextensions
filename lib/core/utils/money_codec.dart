/// Converts between the API's decimal money ("2104.00", or a plain number) and
/// the app's integer minor units. The app stores two minor digits for every
/// currency, matching the API's two-decimal rule.
abstract final class MoneyCodec {
  static const int _minorPerMajor = 100;
  static const int _decimals = 2;

  static int toMinor(Object? value) {
    final amount = double.tryParse('${value ?? 0}') ?? 0;
    return (amount * _minorPerMajor).round();
  }

  static int? toMinorOrNull(Object? value) => value == null ? null : toMinor(value);

  static String toApi(int minor) => (minor / _minorPerMajor).toStringAsFixed(_decimals);

  static String? toApiOrNull(int? minor) => minor == null ? null : toApi(minor);

  static double toDouble(Object? value) => double.tryParse('${value ?? 0}') ?? 0;

  static double? toDoubleOrNull(Object? value) => value == null ? null : toDouble(value);

  /// Percentages and hours also travel as decimal strings.
  static String decimalToApi(double value) => value.toStringAsFixed(_decimals);
}
