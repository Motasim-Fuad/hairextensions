import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';

/// The Figma sample business, used across tests.
abstract final class BusinessProfileFixture {
  static const BusinessProfile glamStrands = BusinessProfile(
    businessName: 'Glam Strands Studio',
    ownerName: 'Amna Khan',
    tagline: 'Luxury hair extensions, Dubai',
    phone: '+971 50 123 4567',
    email: 'hello@glamstrands.ae',
    instagram: '@glamstrands.dxb',
    website: 'glamstrands.ae',
    address: 'Jumeirah 1, Dubai, UAE',
    currencyCode: 'AED',
    taxRatePercent: 5,
    depositType: DepositType.percent,
    depositPercent: 30,
    depositFixedMinor: 0,
    paymentLink: 'https://pay.glamstrands.ae/deposit',
    defaultNote: 'Deposit secures your appointment and is non-refundable. Balance due on the day.',
    quoteValidityDays: 14,
    quotePrefix: 'Q-',
    invoicePrefix: 'INV-',
    nextQuoteNumber: 13,
    nextInvoiceNumber: 6,
  );
}
