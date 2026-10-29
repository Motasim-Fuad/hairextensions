import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/document_row.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_line_text.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

/// Words and formats a quote for the client PDF or the internal cost sheet.
abstract final class QuoteDocumentFactory {
  static const String _pdfExtension = '.pdf';

  static QuoteDocument client(
    AppLocalizations l10n,
    Quote quote,
    BusinessProfile? profile,
  ) {
    final totals = quote.totals;
    final currency = quote.currencyCode;
    final businessName = _businessName(l10n, profile);
    final link = quote.paymentLink;
    return QuoteDocument(
      fileName: '${quote.number}$_pdfExtension',
      apiPath:
          '/v1/${quote.id.startsWith('i') ? 'invoices' : 'quotes'}/${quote.id.substring(1)}/pdf',
      businessName: businessName,
      businessContact: _contact(l10n, profile),
      title: quote.status.isInvoice
          ? l10n.documentInvoice
          : l10n.documentQuotation,
      reference: l10n.documentReference(
        quote.number,
        DateFormatter.dayMonthYear(quote.createdAt),
      ),
      billToLabel: l10n.documentBillTo,
      billTo: [quote.clientName, ?quote.clientPhone].join(l10n.separatorDot),
      descriptionLabel: l10n.documentDescription,
      amountLabel: l10n.documentAmount,
      lines: [
        for (final line in quote.lines)
          DocumentRow(
            label: _lineLabel(l10n, line),
            value: MoneyFormatter.plain(line.amountMinor, showDecimals: true),
          ),
      ],
      summary: [
        DocumentRow(
          label: l10n.labelSubtotal,
          value: MoneyFormatter.plain(totals.subtotalMinor, showDecimals: true),
        ),
        DocumentRow(
          label: l10n.vatRateLabel(
            PercentFormatter.format(quote.vatRatePercent),
          ),
          value: MoneyFormatter.plain(totals.vatMinor, showDecimals: true),
        ),
        DocumentRow(
          label: l10n.labelTotal,
          value: MoneyFormatter.format(totals.totalMinor, currency),
          isEmphasized: true,
        ),
        if (totals.depositMinor > 0) ...[
          DocumentRow(
            label: l10n.labelDeposit,
            value: MoneyFormatter.plain(
              totals.depositMinor,
              showDecimals: true,
            ),
          ),
          DocumentRow(
            label: l10n.labelBalanceDue,
            value: MoneyFormatter.format(totals.balanceMinor, currency),
            isEmphasized: true,
          ),
        ],
      ],
      noteLabel: l10n.documentNote,
      note: quote.note,
      callToAction: link == null || link.isEmpty || totals.depositMinor == 0
          ? null
          : l10n.documentPayDeposit(
              MoneyFormatter.format(
                totals.depositMinor,
                currency,
                showDecimals: false,
              ),
            ),
      footer: l10n.documentThanks(businessName),
    );
  }

  static QuoteDocument internal(
    AppLocalizations l10n,
    Quote quote,
    BusinessProfile? profile,
  ) {
    final totals = quote.totals;
    final currency = quote.currencyCode;
    final perHour = totals.profitPerHourMinor;
    return QuoteDocument(
      fileName: '${quote.number}-${l10n.documentCostSheetFile}$_pdfExtension',
      apiPath:
          '/v1/quotes/${quote.sourceQuoteId ?? quote.id.substring(1)}/cost-sheet/pdf',
      businessName: _businessName(l10n, profile),
      businessContact: _contact(l10n, profile),
      title: l10n.documentCostSheet,
      reference: l10n.documentReference(
        quote.number,
        DateFormatter.dayMonthYear(quote.createdAt),
      ),
      billToLabel: l10n.documentBillTo,
      billTo: quote.clientName,
      descriptionLabel: l10n.documentDescription,
      amountLabel: l10n.documentCostAndPrice,
      lines: [
        for (final line in quote.lines)
          DocumentRow(
            label: _lineLabel(l10n, line),
            value: l10n.documentCostPriceValue(
              MoneyFormatter.plain(line.costMinor, showDecimals: true),
              MoneyFormatter.plain(line.amountMinor, showDecimals: true),
            ),
          ),
      ],
      summary: [
        DocumentRow(
          label: l10n.labelTotal,
          value: MoneyFormatter.format(totals.totalMinor, currency),
        ),
        DocumentRow(
          label: l10n.vatRateLabel(
            PercentFormatter.format(quote.vatRatePercent),
          ),
          value: MoneyFormatter.format(totals.vatMinor, currency),
        ),
        DocumentRow(
          label: l10n.labelCosts,
          value: MoneyFormatter.format(totals.costsMinor, currency),
        ),
        DocumentRow(
          label: l10n.labelProfit,
          value: MoneyFormatter.format(totals.profitMinor, currency),
          isEmphasized: true,
        ),
        DocumentRow(
          label: l10n.labelMargin,
          value: l10n.percentValue(totals.marginPercent.round().toString()),
        ),
        DocumentRow(
          label: l10n.labelHours,
          value: l10n.hoursValue(PercentFormatter.format(totals.hours)),
        ),
        if (perHour != null)
          DocumentRow(
            label: l10n.labelProfitPerHour,
            value: MoneyFormatter.format(perHour, currency),
            isEmphasized: true,
          ),
      ],
      footer: l10n.documentInternalOnly,
    );
  }

  static String _lineLabel(AppLocalizations l10n, QuoteLine line) {
    return switch (line.category) {
      LineCategory.hair => l10n.documentLineDetail(
        line.title,
        l10n.gramsValue('${line.grams ?? 0}'),
      ),
      LineCategory.service =>
        line.hours == null
            ? line.title
            : l10n.documentLineDetail(
                line.title,
                l10n.hoursValue(PercentFormatter.format(line.hours!)),
              ),
      LineCategory.material || LineCategory.addOn =>
        line.quantity > 1
            ? l10n.documentLineQuantity(line.title, line.quantity)
            : line.title,
      LineCategory.shipping => line.displayTitle(l10n),
    };
  }

  static String _businessName(AppLocalizations l10n, BusinessProfile? profile) {
    return profile?.businessName ?? l10n.sampleBusinessName;
  }

  static String _contact(AppLocalizations l10n, BusinessProfile? profile) {
    if (profile == null) {
      return l10n.sampleDocumentContact;
    }
    final parts = [
      profile.phone,
      profile.email,
    ].whereType<String>().where((part) => part.isNotEmpty);
    return parts.join(l10n.separatorDot);
  }
}
