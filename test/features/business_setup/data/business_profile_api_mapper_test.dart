import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_api_mapper.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';


BusinessProfile _profile({
  DepositType depositType = DepositType.percent,
  int depositFixedMinor = 0,
  String email = 'hello@glamstrands.ae',
  String website = 'glamstrands.ae',
  String quotePrefix = 'Q-',
}) {
  return BusinessProfile(
    businessName: 'Glam Strands Studio',
    ownerName: 'Amna Khan',
    tagline: 'Luxury hair extensions, Dubai',
    phone: '+971 50 123 4567',
    email: email,
    instagram: '@glamstrands.dxb',
    website: website,
    address: 'Jumeirah 1, Dubai, UAE',
    currencyCode: 'AED',
    taxRatePercent: 5,
    depositType: depositType,
    depositPercent: 30,
    depositFixedMinor: depositFixedMinor,
    paymentLink: 'https://pay.glamstrands.ae/deposit',
    defaultNote: 'Deposit secures your appointment.',
    quoteValidityDays: 14,
    quotePrefix: quotePrefix,
    invoicePrefix: 'INV-',
    nextQuoteNumber: 13,
    nextInvoiceNumber: 6,
  );
}

void main() {
  Map<String, Object?> body(BusinessProfile profile) =>
      BusinessProfileApiMapper.toApi(BusinessProfileMapper.toModel(profile, createdAt: 1, updatedAt: 2).toJson());

  test('document prefixes keep only A-Z and 0-9, which is all the API accepts', () {
    final result = body(_profile());

    expect(result['quote_prefix'], 'Q');
    expect(result['invoice_prefix'], 'INV');
  });

  test('links without a scheme get https, links with one are kept', () {
    final result = body(_profile());

    expect(result['website'], 'https://glamstrands.ae');
    expect(result['payment_link'], 'https://pay.glamstrands.ae/deposit');
  });

  test('money, tax and deposit travel as decimal strings', () {
    final result = body(_profile());

    expect(result['tax_rate_percent'], '5.00');
    expect(result['deposit_mode'], 'percent');
    expect(result['deposit_value'], '30.00');
    expect(result['currency'], 'AED');
    expect(result['quote_validity_days'], 14);
  });

  test('a fixed deposit is sent in major units', () {
    final fixed = _profile(depositType: DepositType.fixed, depositFixedMinor: 15000);

    final result = body(fixed);

    expect(result['deposit_mode'], 'fixed');
    expect(result['deposit_value'], '150.00');
  });

  test('empty optional fields become null instead of failing e-mail validation', () {
    final blank = _profile(email: '', website: '', quotePrefix: '--');

    final result = body(blank);

    expect(result['email'], isNull);
    expect(result['website'], isNull);
    expect(result['quote_prefix'], isNull);
  });

  test('reads a BusinessRead response back into the local model', () {
    final model = BusinessProfileApiMapper.fromApi({
      'id': 3,
      'business_name': 'Glam Strands Studio',
      'currency': 'AED',
      'tax_rate_percent': '5.00',
      'deposit_mode': 'fixed',
      'deposit_value': '150.00',
      'quote_validity_days': 14,
      'quote_prefix': 'Q',
      'invoice_prefix': 'INV',
      'next_quote_number': 13,
      'next_invoice_number': 6,
      'created_at': '2026-10-24T10:00:00Z',
      'updated_at': '2026-10-25T10:00:00Z',
    });

    expect(model.businessName, 'Glam Strands Studio');
    expect(model.taxRatePercent, 5);
    expect(model.depositType, DepositType.fixed.name);
    expect(model.depositFixedMinor, 15000);
    expect(model.quotePrefix, 'Q');
    expect(model.nextQuoteNumber, 13);
  });
}
