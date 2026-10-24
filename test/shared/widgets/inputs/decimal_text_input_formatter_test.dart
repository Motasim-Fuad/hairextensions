import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/shared/widgets/inputs/decimal_text_input_formatter.dart';

void main() {
  final formatter = DecimalTextInputFormatter();
  const empty = TextEditingValue.empty;

  String apply(String text) => formatter.formatEditUpdate(empty, TextEditingValue(text: text)).text;

  test('accepts up to two decimals', () {
    expect(apply('350.25'), '350.25');
    expect(apply('350.255'), '');
  });

  test('normalizes a comma decimal separator', () {
    expect(apply('3,5'), '3.5');
  });

  test('rejects letters and a second point', () {
    expect(apply('3a'), '');
    expect(apply('3.5.1'), '');
  });
}
