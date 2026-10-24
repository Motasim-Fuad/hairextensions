import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';

/// The business identity and quote defaults. Shared because quotes, PDFs and
/// settings all read it; only the business_setup feature writes it.
class BusinessProfile extends Equatable {
  const BusinessProfile({
    required this.businessName,
    required this.currencyCode,
    required this.taxRatePercent,
    required this.depositType,
    required this.depositPercent,
    required this.depositFixedMinor,
    required this.quoteValidityDays,
    required this.quotePrefix,
    required this.invoicePrefix,
    required this.nextQuoteNumber,
    required this.nextInvoiceNumber,
    this.ownerName,
    this.tagline,
    this.logoPath,
    this.phone,
    this.email,
    this.instagram,
    this.website,
    this.address,
    this.paymentLink,
    this.defaultNote,
    this.pdfAccentColor,
  });

  final String businessName;
  final String? ownerName;
  final String? tagline;
  final String? logoPath;
  final String? phone;
  final String? email;
  final String? instagram;
  final String? website;
  final String? address;
  final String currencyCode;
  final double taxRatePercent;
  final DepositType depositType;
  final double depositPercent;
  final int depositFixedMinor;
  final String? paymentLink;
  final String? defaultNote;
  final int quoteValidityDays;
  final String quotePrefix;
  final String invoicePrefix;
  final int nextQuoteNumber;
  final int nextInvoiceNumber;
  final int? pdfAccentColor;

  /// Name used in greetings: the owner when given, otherwise the business.
  String get greetingName {
    final owner = ownerName?.trim();
    if (owner == null || owner.isEmpty) {
      return businessName;
    }
    return owner.split(' ').first;
  }

  @override
  List<Object?> get props => [
    businessName,
    ownerName,
    tagline,
    logoPath,
    phone,
    email,
    instagram,
    website,
    address,
    currencyCode,
    taxRatePercent,
    depositType,
    depositPercent,
    depositFixedMinor,
    paymentLink,
    defaultNote,
    quoteValidityDays,
    quotePrefix,
    invoicePrefix,
    nextQuoteNumber,
    nextInvoiceNumber,
    pdfAccentColor,
  ];
}
