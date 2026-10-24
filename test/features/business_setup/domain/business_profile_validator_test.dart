import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';
import 'package:hairextensions/features/business_setup/domain/validators/business_profile_validator.dart';

import '../../../fixtures/business_profile_fixture.dart';

void main() {
  final valid = BusinessProfileDraft.fromProfile(BusinessProfileFixture.glamStrands);

  test('the Figma sample business passes every step', () {
    for (final step in SetupStep.values) {
      expect(BusinessProfileValidator.validate(step, valid), isEmpty, reason: step.name);
    }
  });

  group('identity', () {
    test('business name is required, other fields are optional', () {
      final draft = BusinessProfileDraft.fromProfile(null).withValue(SetupField.businessName, '   ');
      expect(BusinessProfileValidator.validate(SetupStep.identity, draft), {
        SetupField.businessName: SetupFieldError.required,
      });
    });

    test('rejects an overly long name', () {
      final draft = valid.withValue(SetupField.businessName, 'x' * 61);
      expect(
        BusinessProfileValidator.validate(SetupStep.identity, draft)[SetupField.businessName],
        SetupFieldError.tooLong,
      );
    });
  });

  group('contact', () {
    test('every contact field is optional', () {
      expect(BusinessProfileValidator.validate(SetupStep.contact, BusinessProfileDraft.fromProfile(null)), isEmpty);
    });

    test('flags malformed email, phone and website', () {
      final draft = valid
          .withValue(SetupField.email, 'hello@')
          .withValue(SetupField.phone, '12ab')
          .withValue(SetupField.website, 'not a site');
      expect(BusinessProfileValidator.validate(SetupStep.contact, draft), {
        SetupField.email: SetupFieldError.invalidEmail,
        SetupField.phone: SetupFieldError.invalidPhone,
        SetupField.website: SetupFieldError.invalidUrl,
      });
    });

    test('accepts common phone formats', () {
      for (final phone in ['+971 50 123 4567', '(050) 123-4567', '0501234567']) {
        final draft = valid.withValue(SetupField.phone, phone);
        expect(BusinessProfileValidator.validate(SetupStep.contact, draft), isEmpty, reason: phone);
      }
    });
  });

  group('quote defaults', () {
    test('tax above 100 and zero validity days are rejected', () {
      final draft = valid.withValue(SetupField.taxRate, '120').withValue(SetupField.validityDays, '0');
      expect(BusinessProfileValidator.validate(SetupStep.quoteDefaults, draft), {
        SetupField.taxRate: SetupFieldError.invalidPercent,
        SetupField.validityDays: SetupFieldError.invalidDays,
      });
    });

    test('a fixed deposit may exceed 100 but a percent deposit may not', () {
      final percent = valid.withValue(SetupField.depositValue, '600');
      final fixed = percent.withDepositType(DepositType.fixed);
      expect(
        BusinessProfileValidator.validate(SetupStep.quoteDefaults, percent)[SetupField.depositValue],
        SetupFieldError.invalidPercent,
      );
      expect(BusinessProfileValidator.validate(SetupStep.quoteDefaults, fixed), isEmpty);
    });

    test('empty required numbers are reported as required', () {
      final draft = valid.withValue(SetupField.taxRate, '').withValue(SetupField.depositValue, '');
      final errors = BusinessProfileValidator.validate(SetupStep.quoteDefaults, draft);
      expect(errors[SetupField.taxRate], SetupFieldError.required);
      expect(errors[SetupField.depositValue], SetupFieldError.required);
    });
  });
}
