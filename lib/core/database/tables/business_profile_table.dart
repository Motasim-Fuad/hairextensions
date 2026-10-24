import 'package:hairextensions/core/database/tables/sync_columns.dart';

/// Single row table (id is always 1) holding the business identity, contact
/// details, quote defaults and document numbering.
abstract final class BusinessProfileTable {
  static const String name = 'business_profile';
  static const int singletonId = 1;
  static const String id = 'id';
  static const String businessName = 'business_name';
  static const String ownerName = 'owner_name';
  static const String tagline = 'tagline';
  static const String logoPath = 'logo_path';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String instagram = 'instagram';
  static const String website = 'website';
  static const String address = 'address';
  static const String currencyCode = 'currency_code';
  static const String taxRatePercent = 'tax_rate_percent';
  static const String depositType = 'deposit_type';
  static const String depositPercent = 'deposit_percent';
  static const String depositFixedMinor = 'deposit_fixed_minor';
  static const String paymentLink = 'payment_link';
  static const String defaultNote = 'default_note';
  static const String quoteValidityDays = 'quote_validity_days';
  static const String quotePrefix = 'quote_prefix';
  static const String invoicePrefix = 'invoice_prefix';
  static const String nextQuoteNumber = 'next_quote_number';
  static const String nextInvoiceNumber = 'next_invoice_number';
  static const String pdfAccentColor = 'pdf_accent_color';
  static const String createTable =
      'CREATE TABLE $name ($id INTEGER PRIMARY KEY CHECK ($id = $singletonId), $businessName TEXT NOT NULL, '
      '$ownerName TEXT, $tagline TEXT, $logoPath TEXT, $phone TEXT, $email TEXT, $instagram TEXT, $website TEXT, '
      '$address TEXT, $currencyCode TEXT NOT NULL, $taxRatePercent REAL NOT NULL DEFAULT 0, '
      '$depositType TEXT NOT NULL, $depositPercent REAL NOT NULL DEFAULT 0, $depositFixedMinor INTEGER NOT NULL DEFAULT 0, '
      '$paymentLink TEXT, $defaultNote TEXT, $quoteValidityDays INTEGER NOT NULL, $quotePrefix TEXT NOT NULL, '
      '$invoicePrefix TEXT NOT NULL, $nextQuoteNumber INTEGER NOT NULL DEFAULT 1, '
      '$nextInvoiceNumber INTEGER NOT NULL DEFAULT 1, $pdfAccentColor INTEGER, ${SyncColumns.definition})';
  static const List<String> createStatements = [
    createTable,
  ];
}
