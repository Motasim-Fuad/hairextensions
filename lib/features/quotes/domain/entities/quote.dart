import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_totals.dart';

class Quote extends Equatable {
  const Quote({
    required this.id,
    required this.number,
    required this.status,
    required this.clientName,
    required this.createdAt,
    required this.validUntil,
    required this.currencyCode,
    required this.vatRatePercent,
    required this.depositMinor,
    this.lines = const [],
    this.sourceQuoteId,
    this.serverStatus,
    this.serverTotals,
    this.clientPhone,
    this.appointment,
    this.note,
    this.paymentLink,
    this.activity = const [],
  });

  final String id;
  final String? sourceQuoteId;
  final String? serverStatus;
  final QuoteTotals? serverTotals;
  final String number;
  final QuoteStatus status;
  final String clientName;
  final String? clientPhone;
  final DateTime? appointment;
  final DateTime createdAt;
  final DateTime validUntil;
  final String currencyCode;
  final double vatRatePercent;
  final int depositMinor;
  final List<QuoteLine> lines;
  final String? note;
  final String? paymentLink;
  final List<QuoteActivity> activity;

  QuoteTotals get totals => serverTotals ?? QuoteTotals.of(this);

  Iterable<QuoteLine> linesIn(LineCategory category) =>
      lines.where((line) => line.category == category);

  Quote copyWith({
    String? id,
    String? number,
    QuoteStatus? status,
    String? clientName,
    String? clientPhone,
    DateTime? appointment,
    DateTime? createdAt,
    DateTime? validUntil,
    double? vatRatePercent,
    int? depositMinor,
    List<QuoteLine>? lines,
    String? note,
    String? paymentLink,
    List<QuoteActivity>? activity,
  }) {
    return Quote(
      id: id ?? this.id,
      sourceQuoteId: sourceQuoteId,
      serverStatus: serverStatus,
      serverTotals:
          lines == null && vatRatePercent == null && depositMinor == null
          ? serverTotals
          : null,
      number: number ?? this.number,
      status: status ?? this.status,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      appointment: appointment ?? this.appointment,
      createdAt: createdAt ?? this.createdAt,
      validUntil: validUntil ?? this.validUntil,
      currencyCode: currencyCode,
      vatRatePercent: vatRatePercent ?? this.vatRatePercent,
      depositMinor: depositMinor ?? this.depositMinor,
      lines: lines ?? this.lines,
      note: note ?? this.note,
      paymentLink: paymentLink ?? this.paymentLink,
      activity: activity ?? this.activity,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sourceQuoteId,
    serverStatus,
    serverTotals,
    number,
    status,
    clientName,
    clientPhone,
    appointment,
    createdAt,
    validUntil,
    currencyCode,
    vatRatePercent,
    depositMinor,
    lines,
    note,
    paymentLink,
    activity,
  ];
}
