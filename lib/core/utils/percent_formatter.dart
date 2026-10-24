import 'package:intl/intl.dart';

/// "5" for 5.0 and "7.5" for 7.5; the percent sign comes from localization.
abstract final class PercentFormatter {
  static final NumberFormat _format = NumberFormat('0.##');

  static String format(double value) => _format.format(value);
}
