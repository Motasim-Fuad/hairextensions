import 'package:hairextensions/core/database/tables/sync_columns.dart';

/// Quotes and invoices. Totals are denormalized so lists and the home summary
/// never load line items. [businessSnapshot] freezes branding at save time.
abstract final class QuotesTable {
  static const String name = 'quotes';
  static const String id = 'id';
  static const String number = 'number';
  static const String documentType = 'document_type';
  static const String status = 'status';
  static const String clientName = 'client_name';
  static const String clientPhone = 'client_phone';
  static const String appointmentAt = 'appointment_at';
  static const String currencyCode = 'currency_code';
  static const String taxRatePercent = 'tax_rate_percent';
  static const String shippingMinor = 'shipping_minor';
  static const String shippingTaxable = 'shipping_taxable';
  static const String depositType = 'deposit_type';
  static const String depositPercent = 'deposit_percent';
  static const String depositFixedMinor = 'deposit_fixed_minor';
  static const String note = 'note';
  static const String paymentLink = 'payment_link';
  static const String validUntil = 'valid_until';
  static const String lockedAt = 'locked_at';
  static const String paidAt = 'paid_at';
  static const String convertedFromId = 'converted_from_id';
  static const String subtotalMinor = 'subtotal_minor';
  static const String taxMinor = 'tax_minor';
  static const String totalMinor = 'total_minor';
  static const String costMinor = 'cost_minor';
  static const String depositMinor = 'deposit_minor';
  static const String bookedHours = 'booked_hours';
  static const String businessSnapshot = 'business_snapshot';
  static const String createTable =
      'CREATE TABLE $name ($id TEXT PRIMARY KEY NOT NULL, $number TEXT NOT NULL, $documentType TEXT NOT NULL, '
      '$status TEXT NOT NULL, $clientName TEXT NOT NULL, $clientPhone TEXT, $appointmentAt INTEGER, '
      '$currencyCode TEXT NOT NULL, $taxRatePercent REAL NOT NULL DEFAULT 0, $shippingMinor INTEGER NOT NULL DEFAULT 0, '
      '$shippingTaxable INTEGER NOT NULL DEFAULT 0, $depositType TEXT NOT NULL, $depositPercent REAL NOT NULL DEFAULT 0, '
      '$depositFixedMinor INTEGER NOT NULL DEFAULT 0, $note TEXT, $paymentLink TEXT, $validUntil INTEGER, '
      '$lockedAt INTEGER, $paidAt INTEGER, $convertedFromId TEXT, $subtotalMinor INTEGER NOT NULL DEFAULT 0, '
      '$taxMinor INTEGER NOT NULL DEFAULT 0, $totalMinor INTEGER NOT NULL DEFAULT 0, $costMinor INTEGER NOT NULL DEFAULT 0, '
      '$depositMinor INTEGER NOT NULL DEFAULT 0, $bookedHours REAL NOT NULL DEFAULT 0, $businessSnapshot TEXT, '
      '${SyncColumns.definition})';
  static const List<String> createStatements = [
    createTable,
    'CREATE INDEX idx_${name}_created ON $name (${SyncColumns.createdAt} DESC)',
    'CREATE INDEX idx_${name}_type_status ON $name ($documentType, $status)',
    'CREATE UNIQUE INDEX idx_${name}_number ON $name ($number)',
  ];
}
