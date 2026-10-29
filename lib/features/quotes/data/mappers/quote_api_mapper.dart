import 'package:hairextensions/features/quotes/domain/entities/quote_totals.dart';
import 'package:hairextensions/core/utils/money_codec.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity_type.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';

typedef Json = Map<String, dynamic>;

/// Translates between the app's [Quote] and the API's quote and invoice
/// shapes. The API owns pricing: the app sends the line inputs and reads the
/// priced result back.
///
/// The app treats a converted quote and its invoice as one record, while the
/// API has two. Their ids are namespaced so they never collide: `q12` is quote
/// 12 and `i7` is invoice 7.
abstract final class QuoteApiMapper {
  static const String quotePrefix = 'q';
  static const String invoicePrefix = 'i';
  static const String _hairSeparator = ' · ';
  static const String _statusInvoiced = 'invoiced';
  static const String _statusPaid = 'paid';
  static const Duration _placeholderValidity = Duration(days: 30);

  static QuoteTotals totalsFromApi(Json value) => QuoteTotals(
    subtotalMinor: MoneyCodec.toMinor(value['subtotal']),
    taxableMinor: MoneyCodec.toMinor(value['taxable_amount']),
    taxableLineCount: 0,
    vatMinor: MoneyCodec.toMinor(value['tax_amount']),
    totalMinor: MoneyCodec.toMinor(value['total']),
    depositMinor: MoneyCodec.toMinor(value['deposit_amount']),
    balanceMinor: MoneyCodec.toMinor(value['balance_due']),
    costsMinor: MoneyCodec.toMinor(value['total_cost']),
    profitMinor: MoneyCodec.toMinor(value['profit']),
    marginPercent: MoneyCodec.toDouble(value['margin_percent']),
    hours: MoneyCodec.toDouble(value['labour_hours']),
    profitPerHourMinor: value['profit_per_hour'] == null
        ? null
        : MoneyCodec.toMinor(value['profit_per_hour']),
  );

  static Quote previewFromApi(Json value, Quote draft) => Quote(
    id: draft.id,
    number: draft.number,
    status: draft.status,
    clientName: draft.clientName,
    clientPhone: draft.clientPhone,
    createdAt: draft.createdAt,
    validUntil: draft.validUntil,
    appointment: draft.appointment,
    currencyCode: value['currency'] as String,
    vatRatePercent: MoneyCodec.toDouble(value['tax_rate_percent']),
    depositMinor: MoneyCodec.toMinor(
      (value['totals'] as Json)['deposit_amount'],
    ),
    // Keep editable inputs; the backend's exact totals are authoritative.
    lines: draft.lines,
    note: draft.note,
    paymentLink: draft.paymentLink,
    serverTotals: totalsFromApi(value['totals'] as Json),
  );

  // ---------------------------------------------------------------- ids

  static String quoteId(int id) => '$quotePrefix$id';

  static String invoiceId(int id) => '$invoicePrefix$id';

  // -------------------------------------------------------------- reads

  /// `QuoteRead` -> [Quote].
  static Quote quoteFromApi(Json json) {
    final createdAt = _dateTime(json['created_at']);
    final sentAt = _dateTimeOrNull(json['sent_at']);
    return Quote(
      id: quoteId((json['id'] as num).toInt()),
      serverStatus: json['status'] as String?,
      number: json['number'] as String,
      status: QuoteStatus.quote,
      clientName: _client(json)['name'] as String? ?? '',
      clientPhone: _client(json)['phone'] as String?,
      appointment: _dateOrNull(json['appointment_date']),
      createdAt: createdAt,
      validUntil:
          _dateOrNull(json['valid_until']) ??
          createdAt.add(_placeholderValidity),
      currencyCode: json['currency'] as String,
      vatRatePercent: MoneyCodec.toDouble(json['tax_rate_percent']),
      depositMinor: MoneyCodec.toMinor(
        (json['totals'] as Json?)?['deposit_amount'],
      ),
      serverTotals: totalsFromApi(json['totals'] as Json),
      lines: _lines(json['lines']),
      note: json['notes'] as String?,
      activity: [
        QuoteActivity(type: QuoteActivityType.created, at: createdAt),
        if (sentAt != null)
          QuoteActivity(type: QuoteActivityType.shared, at: sentAt),
      ],
    );
  }

  /// `InvoiceRead` -> [Quote] with an invoice status.
  static Quote invoiceFromApi(Json json) {
    final createdAt = _dateTime(json['created_at']);
    final paidAt = _dateTimeOrNull(json['paid_at']);
    final isPaid = json['status'] == _statusPaid;
    return Quote(
      id: invoiceId((json['id'] as num).toInt()),
      serverStatus: json['status'] as String?,
      sourceQuoteId: json['quote_id']?.toString(),
      number: json['number'] as String,
      status: isPaid ? QuoteStatus.paid : QuoteStatus.invoice,
      clientName:
          _client(json)['name'] as String? ??
          json['client_name'] as String? ??
          '',
      clientPhone: _client(json)['phone'] as String?,
      createdAt: createdAt,
      validUntil:
          _dateOrNull(json['due_date']) ?? createdAt.add(_placeholderValidity),
      currencyCode: json['currency'] as String,
      vatRatePercent: MoneyCodec.toDouble(json['tax_rate_percent']),
      depositMinor: MoneyCodec.toMinor(json['amount_paid']),
      lines: _lines(json['lines']),
      note: json['notes'] as String?,
      paymentLink: json['payment_link'] as String?,
      activity: [
        QuoteActivity(type: QuoteActivityType.created, at: createdAt),
        QuoteActivity(
          type: QuoteActivityType.convertedToInvoice,
          at: createdAt,
        ),
        if (paidAt != null)
          QuoteActivity(type: QuoteActivityType.markedPaid, at: paidAt),
      ],
    );
  }

  /// `QuoteSummary` -> [Quote] for lists. Summaries carry no lines, so a single
  /// stand-in line reproduces the total and the profit; the full quote is
  /// fetched when a row is opened.
  static Quote quoteFromSummary(Json json) {
    final createdAt = _dateTime(json['created_at']);
    final total = MoneyCodec.toMinor(json['total']);
    final profit = MoneyCodec.toMinor(json['profit']);
    return Quote(
      id: quoteId((json['id'] as num).toInt()),
      serverStatus: json['status'] as String?,
      number: json['number'] as String,
      status: QuoteStatus.quote,
      clientName: json['client_name'] as String? ?? '',
      appointment: _dateOrNull(json['appointment_date']),
      createdAt: createdAt,
      validUntil: createdAt.add(_placeholderValidity),
      currencyCode: json['currency'] as String,
      vatRatePercent: 0,
      depositMinor: 0,
      lines: [_standIn(total: total, profit: profit)],
    );
  }

  /// `InvoiceSummary` -> [Quote]. The deposit is what has been paid so far, so
  /// the balance equals the amount still due.
  static Quote invoiceFromSummary(Json json) {
    final createdAt = _dateTime(json['created_at']);
    final total = MoneyCodec.toMinor(json['total']);
    final due = MoneyCodec.toMinor(json['amount_due']);
    return Quote(
      id: invoiceId((json['id'] as num).toInt()),
      serverStatus: json['status'] as String?,
      sourceQuoteId: json['quote_id']?.toString(),
      number: json['number'] as String,
      status: json['status'] == _statusPaid
          ? QuoteStatus.paid
          : QuoteStatus.invoice,
      clientName: json['client_name'] as String? ?? '',
      createdAt: createdAt,
      validUntil:
          _dateOrNull(json['due_date']) ?? createdAt.add(_placeholderValidity),
      currencyCode: json['currency'] as String,
      vatRatePercent: 0,
      depositMinor: total - due,
      lines: [_standIn(total: total, profit: total)],
    );
  }

  static bool isInvoiced(Json summary) => summary['status'] == _statusInvoiced;

  // ------------------------------------------------------------- writes

  /// Body for `POST /v1/quotes` and `PATCH /v1/quotes/{id}`.
  static Map<String, Object?> quoteToApi(Quote quote) {
    final phone = quote.clientPhone?.trim();
    final note = quote.note?.trim();
    final appointment = quote.appointment;
    return {
      'client': {
        'name': quote.clientName.trim(),
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
      'appointment_date': appointment == null ? null : _date(appointment),
      'valid_until': _date(quote.validUntil),
      'lines': [for (final line in quote.lines) lineToApi(line)],
      'deposit': {
        'mode': 'fixed',
        'value': MoneyCodec.toApi(quote.depositMinor),
      },
      'tax_rate_percent': MoneyCodec.decimalToApi(quote.vatRatePercent),
      'notes': note == null || note.isEmpty ? null : note,
    };
  }

  static Map<String, Object?> lineToApi(QuoteLine line) {
    final base = <String, Object?>{
      'description': _description(line),
      'taxable': line.isTaxable,
    };
    switch (line.category) {
      case LineCategory.hair:
        final grams = line.grams ?? 0;
        final packCount = line.packs ?? 0;
        final wholePacks = packCount > 0;
        final gramsPerPack = wholePacks
            ? (grams + (line.leftoverGrams ?? 0)) / packCount
            : grams.toDouble();
        final packPrice = wholePacks
            ? line.costMinor / packCount
            : line.costMinor.toDouble();
        final markup =
            line.markupPercent ??
            (line.costMinor > 0
                ? (line.amountMinor / line.costMinor - 1) * 100
                : 0);
        return {
          ...base,
          'kind': 'hair',
          'grams_required': grams,
          'grams_per_pack': MoneyCodec.decimalToApi(gramsPerPack),
          'pack_price': MoneyCodec.toApi(packPrice.round()),
          'markup_percent': MoneyCodec.decimalToApi(markup),
          'whole_packs': wholePacks,
        };
      case LineCategory.service:
        final hours = line.hours;
        if (hours != null) {
          return {
            ...base,
            'kind': 'labour',
            'hours': MoneyCodec.decimalToApi(hours),
            'hourly_rate': MoneyCodec.toApi(line.unitPriceMinor),
          };
        }
        return {
          ...base,
          'kind': 'service',
          'quantity': 1,
          'unit_price': MoneyCodec.toApi(line.amountMinor),
          'unit_cost': MoneyCodec.toApi(line.costMinor),
        };
      case LineCategory.material:
      case LineCategory.addOn:
        final quantity = line.quantity <= 0 ? 1 : line.quantity;
        return {
          ...base,
          'kind': line.category == LineCategory.material ? 'material' : 'fee',
          'quantity': quantity,
          'unit_price': MoneyCodec.toApi(line.unitPriceMinor),
          'unit_cost': MoneyCodec.toApi((line.costMinor / quantity).round()),
        };
      case LineCategory.shipping:
        return {
          ...base,
          'kind': 'fee',
          'quantity': 1,
          'unit_price': MoneyCodec.toApi(line.amountMinor),
          'unit_cost': MoneyCodec.toApi(line.amountMinor),
        };
    }
  }

  // ------------------------------------------------------------ private

  static List<QuoteLine> _lines(Object? raw) {
    if (raw is! List) {
      return const [];
    }
    return [for (final item in raw) lineFromApi(item as Json)];
  }

  static QuoteLine lineFromApi(Json json) {
    final id = '${json['id']}';
    final description = json['description'] as String? ?? '';
    final price = MoneyCodec.toMinor(json['price']);
    final cost = MoneyCodec.toMinor(json['cost']);
    final taxable = json['taxable'] as bool? ?? true;
    switch (json['kind']) {
      case 'hair':
        final parts = description.split(_hairSeparator);
        final packs = (json['packs_needed'] as num?)?.toInt();
        final wholePacks = json['whole_packs'] == true && packs != null;
        return QuoteLine(
          id: id,
          category: LineCategory.hair,
          title: parts.first,
          variant: parts.length > 1
              ? parts.sublist(1).join(_hairSeparator)
              : null,
          amountMinor: price,
          costMinor: cost,
          isTaxable: taxable,
          grams: MoneyCodec.toDouble(json['grams_required']).round(),
          packs: wholePacks ? packs : null,
          leftoverGrams: wholePacks
              ? MoneyCodec.toDouble(json['leftover_grams']).round()
              : null,
          markupPercent: MoneyCodec.toDoubleOrNull(json['markup_percent']),
        );
      case 'labour':
        return QuoteLine(
          id: id,
          category: LineCategory.service,
          title: description,
          amountMinor: price,
          costMinor: cost,
          isTaxable: taxable,
          unitPriceMinor: MoneyCodec.toMinor(json['hourly_rate']),
          hours: MoneyCodec.toDouble(json['hours']),
        );
      case 'service':
        return QuoteLine(
          id: id,
          category: LineCategory.service,
          title: description,
          amountMinor: price,
          costMinor: cost,
          isTaxable: taxable,
          unitPriceMinor: price,
        );
      case 'material':
        return _itemLine(
          json,
          id,
          description,
          LineCategory.material,
          price,
          cost,
          taxable,
        );
      default:
        // A fee that passes through at cost is shipping; any other is an add-on.
        final isShipping = price > 0 && price == cost;
        return _itemLine(
          json,
          id,
          description,
          isShipping ? LineCategory.shipping : LineCategory.addOn,
          price,
          cost,
          taxable,
        );
    }
  }

  static QuoteLine _itemLine(
    Json json,
    String id,
    String description,
    LineCategory category,
    int price,
    int cost,
    bool taxable,
  ) {
    final quantity = MoneyCodec.toDouble(json['quantity']).round();
    return QuoteLine(
      id: id,
      category: category,
      title: description,
      amountMinor: price,
      costMinor: cost,
      isTaxable: taxable,
      quantity: quantity <= 0 ? 1 : quantity,
      unitPriceMinor: MoneyCodec.toMinor(json['unit_price']),
    );
  }

  static QuoteLine _standIn({required int total, required int profit}) {
    return QuoteLine(
      id: 'summary',
      category: LineCategory.service,
      title: '',
      amountMinor: total,
      costMinor: total - profit,
      isTaxable: false,
    );
  }

  static String _description(QuoteLine line) {
    final variant = line.variant?.trim();
    if (line.category == LineCategory.hair &&
        variant != null &&
        variant.isNotEmpty) {
      return '${line.title}$_hairSeparator$variant';
    }
    return line.title;
  }

  static Json _client(Json json) => (json['client'] as Json?) ?? const {};

  static DateTime _dateTime(Object? value) =>
      DateTime.tryParse('${value ?? ''}')?.toLocal() ?? DateTime.now();

  static DateTime? _dateTimeOrNull(Object? value) =>
      value == null ? null : DateTime.tryParse('$value')?.toLocal();

  static DateTime? _dateOrNull(Object? value) =>
      value == null ? null : DateTime.tryParse('$value');

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
