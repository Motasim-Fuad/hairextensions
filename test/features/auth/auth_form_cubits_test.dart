import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/features/auth/domain/enums/auth_field_error.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountGateway extends Mock implements AccountGateway {}

void main() {
  late _MockAccountGateway gateway;

  setUp(() {
    gateway = _MockAccountGateway();
  });

  group('LoginCubit', () {
    test('invalid input shows field errors and never calls the gateway', () async {
      final cubit = LoginCubit(gateway);
      await cubit.submit(email: 'nope', password: '');

      expect(cubit.state.emailError, AuthFieldError.invalidEmail);
      expect(cubit.state.passwordError, AuthFieldError.required);
      expect(cubit.state.status, AuthSubmitStatus.idle);
      verifyNever(() => gateway.logIn(email: any(named: 'email'), password: any(named: 'password')));
      await cubit.close();
    });

    test('valid input submits the trimmed email and succeeds', () async {
      when(() => gateway.logIn(email: 'a@b.co', password: 'pw')).thenAnswer((_) async => true);
      final cubit = LoginCubit(gateway);
      await cubit.submit(email: ' a@b.co ', password: 'pw');

      expect(cubit.state.status, AuthSubmitStatus.success);
      await cubit.close();
    });

    test('a rejected or throwing login ends in failure', () async {
      when(() => gateway.logIn(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => false);
      final rejected = LoginCubit(gateway);
      await rejected.submit(email: 'a@b.co', password: 'pw');
      expect(rejected.state.status, AuthSubmitStatus.failure);
      await rejected.close();

      when(() => gateway.logIn(email: any(named: 'email'), password: any(named: 'password'))).thenThrow(Exception('boom'));
      final thrown = LoginCubit(gateway);
      await thrown.submit(email: 'a@b.co', password: 'pw');
      expect(thrown.state.status, AuthSubmitStatus.failure);
      await thrown.close();
    });

    test('editing a field clears its error', () async {
      final cubit = LoginCubit(gateway);
      await cubit.submit(email: '', password: '');
      cubit.emailEdited();

      expect(cubit.state.emailError, isNull);
      expect(cubit.state.passwordError, AuthFieldError.required);
      await cubit.close();
    });

    test('toggling visibility flips the flag', () async {
      final cubit = LoginCubit(gateway)..togglePasswordVisibility();
      expect(cubit.state.passwordVisible, isTrue);
      await cubit.close();
    });
  });

  group('RegisterCubit', () {
    test('every problem is reported at once', () async {
      final cubit = RegisterCubit(gateway);
      await cubit.submit(name: '', email: 'x', password: 'short', confirmPassword: 'other');

      expect(cubit.state.nameError, AuthFieldError.required);
      expect(cubit.state.emailError, AuthFieldError.invalidEmail);
      expect(cubit.state.passwordError, AuthFieldError.passwordTooShort);
      expect(cubit.state.confirmError, AuthFieldError.passwordMismatch);
      expect(cubit.state.termsError, AuthFieldError.termsNotAccepted);
      await cubit.close();
    });

    test('accepting the terms clears only the terms error', () async {
      final cubit = RegisterCubit(gateway);
      await cubit.submit(name: '', email: '', password: '', confirmPassword: '');
      cubit.setTermsAccepted(accepted: true);

      expect(cubit.state.termsError, isNull);
      expect(cubit.state.termsAccepted, isTrue);
      expect(cubit.state.nameError, AuthFieldError.required);
      await cubit.close();
    });

    test('changing the password also clears a confirmation mismatch', () async {
      final cubit = RegisterCubit(gateway);
      await cubit.submit(name: 'A', email: 'a@b.co', password: 'abcdefg1', confirmPassword: 'zzz');
      expect(cubit.state.confirmError, AuthFieldError.passwordMismatch);

      cubit.fieldEdited(RegisterField.password);
      expect(cubit.state.confirmError, isNull);
      await cubit.close();
    });

    test('a valid form registers and succeeds', () async {
      when(
        () => gateway.register(name: 'Amna', email: 'a@b.co', password: 'abcdefg1'),
      ).thenAnswer((_) async => true);
      final cubit = RegisterCubit(gateway)..setTermsAccepted(accepted: true);
      await cubit.submit(name: ' Amna ', email: 'a@b.co', password: 'abcdefg1', confirmPassword: 'abcdefg1');

      expect(cubit.state.status, AuthSubmitStatus.success);
      await cubit.close();
    });
  });

  group('ForgotPasswordCubit', () {
    test('needs a valid email', () async {
      final cubit = ForgotPasswordCubit(gateway);
      await cubit.submit(email: 'nope');

      expect(cubit.state.emailError, AuthFieldError.invalidEmail);
      expect(cubit.state.isSent, isFalse);
      await cubit.close();
    });

    test('a requested link shows the confirmation', () async {
      when(() => gateway.requestPasswordReset(email: 'a@b.co')).thenAnswer((_) async => true);
      final cubit = ForgotPasswordCubit(gateway);
      await cubit.submit(email: 'a@b.co');

      expect(cubit.state.isSent, isTrue);
      await cubit.close();
    });
  });
}
