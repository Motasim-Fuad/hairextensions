import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';

void main() {
  group('AppVersion.tryParse', () {
    test('ignores build metadata and pre-release tags', () {
      expect(AppVersion.tryParse('1.4.2+17'), const AppVersion(1, 4, 2));
      expect(AppVersion.tryParse('2.0.0-beta.1'), const AppVersion(2, 0, 0));
    });

    test('pads missing components with zero', () {
      expect(AppVersion.tryParse('3'), const AppVersion(3, 0, 0));
      expect(AppVersion.tryParse('3.1'), const AppVersion(3, 1, 0));
    });

    test('rejects invalid input', () {
      expect(AppVersion.tryParse(null), isNull);
      expect(AppVersion.tryParse(''), isNull);
      expect(AppVersion.tryParse('1.x.0'), isNull);
    });
  });

  test('compares numerically, not lexically', () {
    expect(const AppVersion(1, 10, 0) < const AppVersion(1, 9, 0), isFalse);
    expect(const AppVersion(1, 9, 9) < const AppVersion(1, 10, 0), isTrue);
  });
}
