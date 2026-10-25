import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';

/// Translates between the API's `BusinessRead` / `BusinessCreate` / `BusinessUpdate`
/// shapes and the app's own profile row. Money crosses the wire as decimal
/// strings ("350.00"); the app stores minor units.
abstract final class BusinessProfileApiMapper {
  static const int _minorPerMajor = 100;
  static const String _percent = 'percent';
  static const String _fixed = 'fixed';
  static const int _maxPrefixLength = 10;
  static final RegExp _notAlphanumeric = RegExp('[^A-Z0-9]');

  /// `BusinessRead` JSON -> local profile model.
  static BusinessProfileModel fromApi(Object? json) {
    final map = json! as Map<String, dynamic>;
    final mode = map['deposit_mode'] as String? ?? _percent;
    final depositValue = _number(map['deposit_value']);
    final isFixed = mode == _fixed;
    return BusinessProfileModel(
      businessName: map['business_name'] as String,
      ownerName: map['owner_name'] as String?,
      tagline: map['tagline'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      instagram: map['instagram'] as String?,
      website: map['website'] as String?,
      address: map['address'] as String?,
      currencyCode: map['currency'] as String,
      taxRatePercent: _number(map['tax_rate_percent']),
      depositType: isFixed ? DepositType.fixed.name : DepositType.percent.name,
      depositPercent: isFixed ? 0 : depositValue,
      depositFixedMinor: isFixed ? (depositValue * _minorPerMajor).round() : 0,
      paymentLink: map['payment_link'] as String?,
      defaultNote: map['quote_terms'] as String?,
      quoteValidityDays: (map['quote_validity_days'] as num).toInt(),
      quotePrefix: map['quote_prefix'] as String,
      invoicePrefix: map['invoice_prefix'] as String,
      nextQuoteNumber: (map['next_quote_number'] as num?)?.toInt() ?? 1,
      nextInvoiceNumber: (map['next_invoice_number'] as num?)?.toInt() ?? 1,
      createdAt: _millis(map['created_at']),
      updatedAt: _millis(map['updated_at']),
    );
  }

  /// Local profile row (as queued for sync) -> body for `POST /v1/businesses`
  /// and `PATCH /v1/business`. Document numbers are owned by the server and the
  /// accent colour and logo path never leave the device, so none of them are sent.
  static Map<String, Object?> toApi(Map<String, Object?> row) {
    final isFixed = row[BusinessProfileTable.depositType] == DepositType.fixed.name;
    final fixedMinor = (row[BusinessProfileTable.depositFixedMinor] as num?)?.toInt() ?? 0;
    final percent = (row[BusinessProfileTable.depositPercent] as num?)?.toDouble() ?? 0;
    return {
      'business_name': row[BusinessProfileTable.businessName],
      'owner_name': _text(row[BusinessProfileTable.ownerName]),
      'tagline': _text(row[BusinessProfileTable.tagline]),
      'phone': _text(row[BusinessProfileTable.phone]),
      'email': _text(row[BusinessProfileTable.email]),
      'address': _text(row[BusinessProfileTable.address]),
      'instagram': _text(row[BusinessProfileTable.instagram]),
      'website': _url(row[BusinessProfileTable.website]),
      'payment_link': _url(row[BusinessProfileTable.paymentLink]),
      'quote_prefix': _prefix(row[BusinessProfileTable.quotePrefix]),
      'invoice_prefix': _prefix(row[BusinessProfileTable.invoicePrefix]),
      'currency': row[BusinessProfileTable.currencyCode],
      'tax_rate_percent': ((row[BusinessProfileTable.taxRatePercent] as num?) ?? 0).toStringAsFixed(2),
      'deposit_mode': isFixed ? _fixed : _percent,
      'deposit_value': isFixed ? (fixedMinor / _minorPerMajor).toStringAsFixed(2) : percent.toStringAsFixed(2),
      'quote_validity_days': row[BusinessProfileTable.quoteValidityDays],
      'quote_terms': _text(row[BusinessProfileTable.defaultNote]),
    };
  }

  /// Empty strings become null: the API validates e-mail addresses and would
  /// reject "" for a field the stylist simply left blank.
  static String? _text(Object? value) {
    final text = value is String ? value.trim() : null;
    return text == null || text.isEmpty ? null : text;
  }

  /// The API only accepts 1-10 characters from A-Z and 0-9 ("Q-" becomes "Q").
  static String? _prefix(Object? value) {
    final cleaned = (value is String ? value : '').toUpperCase().replaceAll(_notAlphanumeric, '');
    if (cleaned.isEmpty) {
      return null;
    }
    return cleaned.length > _maxPrefixLength ? cleaned.substring(0, _maxPrefixLength) : cleaned;
  }

  /// The API requires a full http(s) link; "yourstudio.com" becomes "https://yourstudio.com".
  static String? _url(Object? value) {
    final text = _text(value)?.replaceAll(RegExp(r'\s'), '');
    if (text == null || text.isEmpty) {
      return null;
    }
    return text.startsWith('http://') || text.startsWith('https://') ? text : 'https://$text';
  }

  static double _number(Object? value) => double.tryParse('${value ?? 0}') ?? 0;

  static int _millis(Object? value) {
    return DateTime.tryParse('${value ?? ''}')?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
  }
}
