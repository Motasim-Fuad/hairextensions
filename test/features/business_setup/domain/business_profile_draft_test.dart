import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/domain/constants/business_profile_defaults.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';

import '../../../fixtures/business_profile_fixture.dart';

void main() {
  const profile = BusinessProfileFixture.glamStrands;

  test('a new business starts with the documented defaults', () {
    final draft = BusinessProfileDraft.fromProfile(null);
    expect(draft.currencyCode, BusinessProfileDefaults.currencyCode);
    expect(draft.valueOf(SetupField.taxRate), BusinessProfileDefaults.taxRate);
    expect(draft.valueOf(SetupField.depositValue), BusinessProfileDefaults.depositPercent);
    expect(draft.valueOf(SetupField.validityDays), BusinessProfileDefaults.validityDays);
    expect(draft.depositType, DepositType.percent);
  });

  test('profile to draft and back is lossless', () {
    expect(BusinessProfileDraft.fromProfile(profile).toProfile(base: profile), profile);
  });

  test('blank optional fields become null and text is trimmed', () {
    final result = BusinessProfileDraft.fromProfile(profile)
        .withValue(SetupField.businessName, '  Glam Strands Studio  ')
        .withValue(SetupField.tagline, '   ')
        .toProfile(base: profile);
    expect(result.businessName, 'Glam Strands Studio');
    expect(result.tagline, isNull);
  });

  test('a fixed deposit is stored in minor units and keeps the saved percent', () {
    final result = BusinessProfileDraft.fromProfile(
      profile,
    ).withDepositType(DepositType.fixed).withValue(SetupField.depositValue, '600.50').toProfile(base: profile);
    expect(result.depositFixedMinor, 60050);
    expect(result.depositPercent, profile.depositPercent);
  });

  test('numbering and accent are preserved from the base profile', () {
    final result = BusinessProfileDraft.fromProfile(profile).toProfile(base: profile);
    expect(result.nextQuoteNumber, 13);
    expect(result.nextInvoiceNumber, 6);
  });

  test('a first save uses default prefixes and starts numbering at one', () {
    final result = BusinessProfileDraft.fromProfile(null).withValue(SetupField.businessName, 'Studio').toProfile();
    expect(result.quotePrefix, BusinessProfileDefaults.quotePrefix);
    expect(result.invoicePrefix, BusinessProfileDefaults.invoicePrefix);
    expect(result.nextQuoteNumber, BusinessProfileDefaults.firstDocumentNumber);
  });
}
