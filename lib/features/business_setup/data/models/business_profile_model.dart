import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/database/tables/sync_columns.dart';

/// Row and JSON shape of the business profile. The API mirrors the column
/// names, so one set of keys serves both. The logo path is device-local and
/// never sent.
class BusinessProfileModel {
  const BusinessProfileModel({
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
    required this.createdAt,
    required this.updatedAt,
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

  factory BusinessProfileModel.fromRow(Map<String, Object?> row) {
    return BusinessProfileModel(
      businessName: row[BusinessProfileTable.businessName]! as String,
      ownerName: row[BusinessProfileTable.ownerName] as String?,
      tagline: row[BusinessProfileTable.tagline] as String?,
      logoPath: row[BusinessProfileTable.logoPath] as String?,
      phone: row[BusinessProfileTable.phone] as String?,
      email: row[BusinessProfileTable.email] as String?,
      instagram: row[BusinessProfileTable.instagram] as String?,
      website: row[BusinessProfileTable.website] as String?,
      address: row[BusinessProfileTable.address] as String?,
      currencyCode: row[BusinessProfileTable.currencyCode]! as String,
      taxRatePercent: (row[BusinessProfileTable.taxRatePercent]! as num).toDouble(),
      depositType: row[BusinessProfileTable.depositType]! as String,
      depositPercent: (row[BusinessProfileTable.depositPercent]! as num).toDouble(),
      depositFixedMinor: (row[BusinessProfileTable.depositFixedMinor]! as num).toInt(),
      paymentLink: row[BusinessProfileTable.paymentLink] as String?,
      defaultNote: row[BusinessProfileTable.defaultNote] as String?,
      quoteValidityDays: (row[BusinessProfileTable.quoteValidityDays]! as num).toInt(),
      quotePrefix: row[BusinessProfileTable.quotePrefix]! as String,
      invoicePrefix: row[BusinessProfileTable.invoicePrefix]! as String,
      nextQuoteNumber: (row[BusinessProfileTable.nextQuoteNumber]! as num).toInt(),
      nextInvoiceNumber: (row[BusinessProfileTable.nextInvoiceNumber]! as num).toInt(),
      pdfAccentColor: (row[BusinessProfileTable.pdfAccentColor] as num?)?.toInt(),
      createdAt: (row[SyncColumns.createdAt]! as num).toInt(),
      updatedAt: (row[SyncColumns.updatedAt]! as num).toInt(),
    );
  }

  factory BusinessProfileModel.fromJson(Object? json) {
    final map = Map<String, Object?>.of(json! as Map<String, dynamic>);
    return BusinessProfileModel.fromRow({...map, BusinessProfileTable.logoPath: null});
  }

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
  final String depositType;
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
  final int createdAt;
  final int updatedAt;

  Map<String, Object?> toRow({required String syncStatus}) {
    return {
      BusinessProfileTable.id: BusinessProfileTable.singletonId,
      ..._fields(),
      BusinessProfileTable.logoPath: logoPath,
      SyncColumns.syncStatus: syncStatus,
    };
  }

  Map<String, Object?> toJson() => _fields();

  Map<String, Object?> _fields() {
    return {
      BusinessProfileTable.businessName: businessName,
      BusinessProfileTable.ownerName: ownerName,
      BusinessProfileTable.tagline: tagline,
      BusinessProfileTable.phone: phone,
      BusinessProfileTable.email: email,
      BusinessProfileTable.instagram: instagram,
      BusinessProfileTable.website: website,
      BusinessProfileTable.address: address,
      BusinessProfileTable.currencyCode: currencyCode,
      BusinessProfileTable.taxRatePercent: taxRatePercent,
      BusinessProfileTable.depositType: depositType,
      BusinessProfileTable.depositPercent: depositPercent,
      BusinessProfileTable.depositFixedMinor: depositFixedMinor,
      BusinessProfileTable.paymentLink: paymentLink,
      BusinessProfileTable.defaultNote: defaultNote,
      BusinessProfileTable.quoteValidityDays: quoteValidityDays,
      BusinessProfileTable.quotePrefix: quotePrefix,
      BusinessProfileTable.invoicePrefix: invoicePrefix,
      BusinessProfileTable.nextQuoteNumber: nextQuoteNumber,
      BusinessProfileTable.nextInvoiceNumber: nextInvoiceNumber,
      BusinessProfileTable.pdfAccentColor: pdfAccentColor,
      SyncColumns.createdAt: createdAt,
      SyncColumns.updatedAt: updatedAt,
    };
  }
}
