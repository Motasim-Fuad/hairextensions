import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/document_row.dart';

/// A fully worded, formatted document. The on-screen preview and the PDF
/// render the same instance, so what the stylist sees is what the client gets.
class QuoteDocument extends Equatable {
  const QuoteDocument({
    required this.fileName,
    required this.businessName,
    required this.businessContact,
    required this.title,
    required this.reference,
    required this.billToLabel,
    required this.billTo,
    required this.descriptionLabel,
    required this.amountLabel,
    required this.lines,
    required this.summary,
    required this.footer,
    this.noteLabel,
    this.apiPath,
    this.note,
    this.callToAction,
  });

  final String fileName;
  final String? apiPath;
  final String businessName;
  final String businessContact;
  final String title;
  final String reference;
  final String billToLabel;
  final String billTo;
  final String descriptionLabel;
  final String amountLabel;
  final List<DocumentRow> lines;
  final List<DocumentRow> summary;
  final String? noteLabel;
  final String? note;
  final String? callToAction;
  final String footer;

  @override
  List<Object?> get props => [
    fileName,
    businessName,
    businessContact,
    title,
    reference,
    billToLabel,
    billTo,
    descriptionLabel,
    amountLabel,
    lines,
    summary,
    noteLabel,
    note,
    callToAction,
    footer,
  ];
}
