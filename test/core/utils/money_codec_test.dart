import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/utils/money_codec.dart';

void main() {
  test('decimal strings and numbers become minor units', () {
    expect(MoneyCodec.toMinor('2104.00'), 210400);
    expect(MoneyCodec.toMinor('12.3'), 1230);
    expect(MoneyCodec.toMinor(7), 700);
    expect(MoneyCodec.toMinor(null), 0);
    expect(MoneyCodec.toMinor('0.29'), 29);
  });

  test('minor units become two-decimal strings', () {
    expect(MoneyCodec.toApi(210400), '2104.00');
    expect(MoneyCodec.toApi(5), '0.05');
    expect(MoneyCodec.toApiOrNull(null), isNull);
  });

  test('a value survives the round trip', () {
    for (final minor in [0, 1, 99, 100, 123456]) {
      expect(MoneyCodec.toMinor(MoneyCodec.toApi(minor)), minor);
    }
  });
}
