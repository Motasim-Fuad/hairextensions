import 'package:flutter/services.dart';

/// Accepts digits and a single decimal point with at most [decimals] places.
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimals = 2}) : _pattern = RegExp('^\\d*\\.?\\d{0,$decimals}\$');

  final int decimals;
  final RegExp _pattern;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final normalized = newValue.text.replaceAll(',', '.');
    if (!_pattern.hasMatch(normalized)) {
      return oldValue;
    }
    return newValue.copyWith(text: normalized);
  }
}
