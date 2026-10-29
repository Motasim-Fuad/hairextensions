part of 'quote_builder_cubit.dart';

final class QuoteBuilderState extends Equatable {
  const QuoteBuilderState({
    required this.status,
    required this.id,
    required this.createdAt,
    this.kind = QuoteStatus.quote,
    this.quoteNumber = '',
    this.invoiceNumber = '',
    this.clientName = '',
    this.clientPhone = '',
    this.appointment,
    this.lines = const [],
    this.currency = QuoteFallbacks.currency,
    this.vatRatePercent = QuoteFallbacks.vatRatePercent,
    this.validityDays = QuoteFallbacks.validityDays,
    this.depositType = DepositType.percent,
    this.depositPercent = 0,
    this.depositFixedMinor = 0,
    this.shippingMinor = 0,
    this.shippingTaxable = false,
    this.note = '',
    this.paymentLink = '',
    this.showErrors = false,
    this.serverQuote,
  });

  static const double _percent = 100;
  static const String shippingLineId = 'shipping';

  final Quote? serverQuote;
  final ViewStatus status;
  final String id;
  final DateTime createdAt;
  final QuoteStatus kind;
  final String quoteNumber;
  final String invoiceNumber;
  final String clientName;
  final String clientPhone;
  final DateTime? appointment;
  final List<QuoteLine> lines;
  final String currency;
  final double vatRatePercent;
  final int validityDays;
  final DepositType depositType;
  final double depositPercent;
  final int depositFixedMinor;
  final int shippingMinor;
  final bool shippingTaxable;
  final String note;
  final String paymentLink;
  final bool showErrors;

  String get number => kind.isInvoice ? invoiceNumber : quoteNumber;

  bool get isClientMissing => clientName.trim().isEmpty;

  bool get showClientError => showErrors && isClientMissing;

  bool get hasLines => lines.isNotEmpty;

  bool get showLinesError => showErrors && !hasLines;

  Quote get quote {
    if (serverQuote != null) return serverQuote!;
    final draft = Quote(
      id: id,
      number: number,
      status: kind,
      clientName: clientName.trim(),
      clientPhone: _orNull(clientPhone),
      appointment: appointment,
      createdAt: createdAt,
      validUntil: createdAt.add(Duration(days: validityDays)),
      currencyCode: currency,
      vatRatePercent: vatRatePercent,
      depositMinor: 0,
      lines: [
        ...lines,
        if (shippingMinor > 0)
          QuoteLineFactory.shipping(
            id: shippingLineId,
            title: '',
            amountMinor: shippingMinor,
            isTaxable: shippingTaxable,
          ),
      ],
      note: _orNull(note),
      paymentLink: _orNull(paymentLink),
    );
    final deposit = depositType == DepositType.fixed
        ? depositFixedMinor
        : (draft.totals.totalMinor * depositPercent / _percent).round();
    return draft.copyWith(depositMinor: deposit);
  }

  int sectionTotal(LineCategory category) {
    return lines
        .where((line) => line.category == category)
        .fold(0, (sum, line) => sum + line.amountMinor);
  }

  static String? _orNull(String value) =>
      value.trim().isEmpty ? null : value.trim();

  QuoteBuilderState copyWith({
    String? id,
    Quote? serverQuote,
    ViewStatus? status,
    QuoteStatus? kind,
    String? quoteNumber,
    String? invoiceNumber,
    String? clientName,
    String? clientPhone,
    DateTime? appointment,
    List<QuoteLine>? lines,
    String? currency,
    double? vatRatePercent,
    int? validityDays,
    DepositType? depositType,
    double? depositPercent,
    int? depositFixedMinor,
    int? shippingMinor,
    bool? shippingTaxable,
    String? note,
    String? paymentLink,
    bool? showErrors,
  }) {
    return QuoteBuilderState(
      status: status ?? this.status,
      serverQuote: serverQuote,
      id: id ?? this.id,
      createdAt: createdAt,
      kind: kind ?? this.kind,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      appointment: appointment ?? this.appointment,
      lines: lines ?? this.lines,
      currency: currency ?? this.currency,
      vatRatePercent: vatRatePercent ?? this.vatRatePercent,
      validityDays: validityDays ?? this.validityDays,
      depositType: depositType ?? this.depositType,
      depositPercent: depositPercent ?? this.depositPercent,
      depositFixedMinor: depositFixedMinor ?? this.depositFixedMinor,
      shippingMinor: shippingMinor ?? this.shippingMinor,
      shippingTaxable: shippingTaxable ?? this.shippingTaxable,
      note: note ?? this.note,
      paymentLink: paymentLink ?? this.paymentLink,
      showErrors: showErrors ?? this.showErrors,
    );
  }

  @override
  List<Object?> get props => [
    status,
    serverQuote,
    id,
    createdAt,
    kind,
    quoteNumber,
    invoiceNumber,
    clientName,
    clientPhone,
    appointment,
    lines,
    currency,
    vatRatePercent,
    validityDays,
    depositType,
    depositPercent,
    depositFixedMinor,
    shippingMinor,
    shippingTaxable,
    note,
    paymentLink,
    showErrors,
  ];
}
