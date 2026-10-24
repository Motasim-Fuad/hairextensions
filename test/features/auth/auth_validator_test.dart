import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/domain/validators/auth_validator.dart';

void main() {
  group('name', () {
    test('is required', () {
      expect(AuthValidator.name('  '), AuthFieldError.required);
      expect(AuthValidator.name('Amna Sheen'), isNull);
    });
  });

  group('email', () {
    test('is required', () {
      expect(AuthValidator.email(''), AuthFieldError.required);
    });

    test('must look like an address', () {
      expect(AuthValidator.email('amna'), AuthFieldError.invalidEmail);
      expect(AuthValidator.email('amna@site'), AuthFieldError.invalidEmail);
      expect(AuthValidator.email('amna@site.com'), isNull);
      expect(AuthValidator.email('  amna@site.com  '), isNull);
    });
  });

  group('passwords', () {
    test('login only requires one to be entered', () {
      expect(AuthValidator.existingPassword(''), AuthFieldError.required);
      expect(AuthValidator.existingPassword('x'), isNull);
    });

    test('a new password needs length, a letter and a number', () {
      expect(AuthValidator.newPassword(''), AuthFieldError.required);
      expect(AuthValidator.newPassword('abc123'), AuthFieldError.passwordTooShort);
      expect(AuthValidator.newPassword('abcdefgh'), AuthFieldError.passwordTooWeak);
      expect(AuthValidator.newPassword('12345678'), AuthFieldError.passwordTooWeak);
      expect(AuthValidator.newPassword('abcdefg1'), isNull);
    });

    test('the confirmation must match', () {
      expect(AuthValidator.confirmPassword('abcdefg1', ''), AuthFieldError.required);
      expect(AuthValidator.confirmPassword('abcdefg1', 'abcdefg2'), AuthFieldError.passwordMismatch);
      expect(AuthValidator.confirmPassword('abcdefg1', 'abcdefg1'), isNull);
    });
  });

  test('terms must be accepted', () {
    expect(AuthValidator.terms(accepted: false), AuthFieldError.termsNotAccepted);
    expect(AuthValidator.terms(accepted: true), isNull);
  });
}
