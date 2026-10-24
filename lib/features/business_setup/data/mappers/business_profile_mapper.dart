import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';

abstract final class BusinessProfileMapper {
  static BusinessProfile toEntity(BusinessProfileModel model) {
    return BusinessProfile(
      businessName: model.businessName,
      ownerName: model.ownerName,
      tagline: model.tagline,
      logoPath: model.logoPath,
      phone: model.phone,
      email: model.email,
      instagram: model.instagram,
      website: model.website,
      address: model.address,
      currencyCode: model.currencyCode,
      taxRatePercent: model.taxRatePercent,
      depositType: DepositType.fromName(model.depositType),
      depositPercent: model.depositPercent,
      depositFixedMinor: model.depositFixedMinor,
      paymentLink: model.paymentLink,
      defaultNote: model.defaultNote,
      quoteValidityDays: model.quoteValidityDays,
      quotePrefix: model.quotePrefix,
      invoicePrefix: model.invoicePrefix,
      nextQuoteNumber: model.nextQuoteNumber,
      nextInvoiceNumber: model.nextInvoiceNumber,
      pdfAccentColor: model.pdfAccentColor,
    );
  }

  static BusinessProfileModel toModel(BusinessProfile entity, {required int createdAt, required int updatedAt}) {
    return BusinessProfileModel(
      businessName: entity.businessName,
      ownerName: entity.ownerName,
      tagline: entity.tagline,
      logoPath: entity.logoPath,
      phone: entity.phone,
      email: entity.email,
      instagram: entity.instagram,
      website: entity.website,
      address: entity.address,
      currencyCode: entity.currencyCode,
      taxRatePercent: entity.taxRatePercent,
      depositType: entity.depositType.name,
      depositPercent: entity.depositPercent,
      depositFixedMinor: entity.depositFixedMinor,
      paymentLink: entity.paymentLink,
      defaultNote: entity.defaultNote,
      quoteValidityDays: entity.quoteValidityDays,
      quotePrefix: entity.quotePrefix,
      invoicePrefix: entity.invoicePrefix,
      nextQuoteNumber: entity.nextQuoteNumber,
      nextInvoiceNumber: entity.nextInvoiceNumber,
      pdfAccentColor: entity.pdfAccentColor,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
