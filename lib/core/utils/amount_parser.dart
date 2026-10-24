import 'package:hairextensions/core/utils/money_formatter.dart';

/// Reads numbers typed into fields. Empty or invalid input reads as zero so
/// live previews never throw; validation happens on submit.
abstract final class AmountParser {
  static int toMinor(String text) => (decimal(text) * MoneyFormatter.minorPerMajor).round();

  static double decimal(String text) => double.tryParse(text.replaceAll(',', '').trim()) ?? 0;

  static int integer(String text) => int.tryParse(text.replaceAll(',', '').trim()) ?? 0;

  /// Editable text for a stored amount, for example 35000 -> "350.00".
  static String fromMinor(int minor) => minor == 0 ? '' : (minor / MoneyFormatter.minorPerMajor).toStringAsFixed(2);
}
