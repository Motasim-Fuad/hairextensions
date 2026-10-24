import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/business_setup/domain/constants/business_profile_defaults.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';

/// The form exactly as typed. Numbers stay text so validation can tell an
/// empty field from a zero, and parsing happens once in [toProfile].
class BusinessProfileDraft extends Equatable {
  const BusinessProfileDraft({
    required this.values,
    required this.currencyCode,
    required this.depositType,
    this.logoPath,
  });

  factory BusinessProfileDraft.fromProfile(BusinessProfile? profile) {
    if (profile == null) {
      return const BusinessProfileDraft(
        values: {
          SetupField.taxRate: BusinessProfileDefaults.taxRate,
          SetupField.depositValue: BusinessProfileDefaults.depositPercent,
          SetupField.validityDays: BusinessProfileDefaults.validityDays,
        },
        currencyCode: BusinessProfileDefaults.currencyCode,
        depositType: BusinessProfileDefaults.depositType,
      );
    }
    final depositValue = profile.depositType == DepositType.percent
        ? _formatNumber(profile.depositPercent)
        : _formatNumber(profile.depositFixedMinor / MoneyFormatter.minorPerMajor);
    return BusinessProfileDraft(
      values: {
        SetupField.businessName: profile.businessName,
        SetupField.ownerName: ?profile.ownerName,
        SetupField.tagline: ?profile.tagline,
        SetupField.phone: ?profile.phone,
        SetupField.email: ?profile.email,
        SetupField.instagram: ?profile.instagram,
        SetupField.website: ?profile.website,
        SetupField.address: ?profile.address,
        SetupField.taxRate: _formatNumber(profile.taxRatePercent),
        SetupField.depositValue: depositValue,
        SetupField.paymentLink: ?profile.paymentLink,
        SetupField.defaultNote: ?profile.defaultNote,
        SetupField.validityDays: '${profile.quoteValidityDays}',
      },
      currencyCode: profile.currencyCode,
      depositType: profile.depositType,
      logoPath: profile.logoPath,
    );
  }

  final Map<SetupField, String> values;
  final String currencyCode;
  final DepositType depositType;
  final String? logoPath;

  String valueOf(SetupField field) => values[field] ?? '';

  String? optionalValueOf(SetupField field) {
    final trimmed = valueOf(field).trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  BusinessProfileDraft withValue(SetupField field, String value) {
    return BusinessProfileDraft(
      values: {...values, field: value},
      currencyCode: currencyCode,
      depositType: depositType,
      logoPath: logoPath,
    );
  }

  BusinessProfileDraft withCurrency(String code) {
    return BusinessProfileDraft(values: values, currencyCode: code, depositType: depositType, logoPath: logoPath);
  }

  BusinessProfileDraft withDepositType(DepositType type) {
    return BusinessProfileDraft(values: values, currencyCode: currencyCode, depositType: type, logoPath: logoPath);
  }

  BusinessProfileDraft withLogo(String? path) {
    return BusinessProfileDraft(values: values, currencyCode: currencyCode, depositType: depositType, logoPath: path);
  }

  /// Merges onto [base] so fields this flow does not edit (numbering, PDF
  /// accent) are preserved. Call only after validation passed.
  BusinessProfile toProfile({BusinessProfile? base}) {
    final depositValue = double.tryParse(valueOf(SetupField.depositValue)) ?? 0;
    final isPercent = depositType == DepositType.percent;
    return BusinessProfile(
      businessName: valueOf(SetupField.businessName).trim(),
      ownerName: optionalValueOf(SetupField.ownerName),
      tagline: optionalValueOf(SetupField.tagline),
      logoPath: logoPath,
      phone: optionalValueOf(SetupField.phone),
      email: optionalValueOf(SetupField.email),
      instagram: optionalValueOf(SetupField.instagram),
      website: optionalValueOf(SetupField.website),
      address: optionalValueOf(SetupField.address),
      currencyCode: currencyCode,
      taxRatePercent: double.tryParse(valueOf(SetupField.taxRate)) ?? 0,
      depositType: depositType,
      depositPercent: isPercent ? depositValue : base?.depositPercent ?? 0,
      depositFixedMinor: isPercent
          ? base?.depositFixedMinor ?? 0
          : (depositValue * MoneyFormatter.minorPerMajor).round(),
      paymentLink: optionalValueOf(SetupField.paymentLink),
      defaultNote: optionalValueOf(SetupField.defaultNote),
      quoteValidityDays: int.tryParse(valueOf(SetupField.validityDays)) ?? 0,
      quotePrefix: base?.quotePrefix ?? BusinessProfileDefaults.quotePrefix,
      invoicePrefix: base?.invoicePrefix ?? BusinessProfileDefaults.invoicePrefix,
      nextQuoteNumber: base?.nextQuoteNumber ?? BusinessProfileDefaults.firstDocumentNumber,
      nextInvoiceNumber: base?.nextInvoiceNumber ?? BusinessProfileDefaults.firstDocumentNumber,
      pdfAccentColor: base?.pdfAccentColor,
    );
  }

  static String _formatNumber(num value) {
    return value == value.roundToDouble() ? '${value.round()}' : '$value';
  }

  @override
  List<Object?> get props => [values, currencyCode, depositType, logoPath];
}
