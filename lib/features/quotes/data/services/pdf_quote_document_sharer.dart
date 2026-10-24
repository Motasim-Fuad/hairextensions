import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/theme/brand_palette.dart';
import 'package:hairextensions/features/quotes/domain/entities/document_row.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_document_sharer.dart';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// A4 layout mirroring the in-app preview. Uses the app's bundled fonts so
/// symbols such as "·", "×" and "”" render. Helvetica cannot be embedded
/// (licensed), so the PDF uses Arimo, its metric-compatible equivalent.
@LazySingleton(as: QuoteDocumentSharer)
class PdfQuoteDocumentSharer implements QuoteDocumentSharer {
  static const String _bodyFont = 'assets/fonts/Arimo.ttf';
  static const String _displayFont = 'assets/fonts/PlayfairDisplay.ttf';
  static const double _margin = 40;
  static const double _gap = 16;
  static const double _small = 9;
  static const double _body = 11;
  static const double _title = 22;
  static const double _monogram = 44;

  @override
  Future<Either<Failure, Unit>> share(QuoteDocument document) async {
    try {
      final bytes = await _render(document);
      await Printing.sharePdf(bytes: bytes, filename: document.fileName);
      return const Right(unit);
    } on Object catch (error) {
      AppLogger.error('PdfQuoteDocumentSharer', 'share failed', error);
      return const Left(UnknownFailure());
    }
  }

  Future<Uint8List> _render(QuoteDocument doc) async {
    final body = pw.Font.ttf(await rootBundle.load(_bodyFont));
    final display = pw.Font.ttf(await rootBundle.load(_displayFont));
    final primary = PdfColor.fromInt(BrandPalette.primary.toARGB32());
    final muted = PdfColor.fromInt(BrandPalette.inkMuted.toARGB32());
    final line = PdfColor.fromInt(BrandPalette.line.toARGB32());
    final pdf =
        pw.Document(
          theme: pw.ThemeData.withFont(base: body, bold: body),
        )..addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(_margin),
            build: (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: _monogram,
                      height: _monogram,
                      alignment: pw.Alignment.center,
                      decoration: pw.BoxDecoration(color: primary, borderRadius: pw.BorderRadius.circular(12)),
                      child: pw.Text(
                        _initials(doc.businessName),
                        style: pw.TextStyle(font: display, color: PdfColors.white, fontSize: 16),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(doc.businessName, style: pw.TextStyle(font: display, fontSize: 16)),
                          pw.Text(
                            doc.businessContact,
                            style: pw.TextStyle(fontSize: _small, color: muted),
                          ),
                        ],
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          doc.title,
                          style: pw.TextStyle(font: display, fontSize: _title, color: primary),
                        ),
                        pw.Text(
                          doc.reference,
                          style: pw.TextStyle(fontSize: _small, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: _gap * 2),
                pw.Text(
                  doc.billToLabel,
                  style: pw.TextStyle(fontSize: _small, color: muted, letterSpacing: 0.6),
                ),
                pw.SizedBox(height: 4),
                pw.Text(doc.billTo, style: const pw.TextStyle(fontSize: _body)),
                pw.SizedBox(height: _gap),
                _row(DocumentRow(label: doc.descriptionLabel, value: doc.amountLabel), muted, line, isHeader: true),
                for (final row in doc.lines) _row(row, null, line),
                pw.SizedBox(height: _gap / 2),
                for (final row in doc.summary) _summaryRow(row, primary),
                if (doc.note != null) ...[
                  pw.SizedBox(height: _gap),
                  pw.Text(
                    doc.noteLabel ?? '',
                    style: pw.TextStyle(fontSize: _small, color: muted, letterSpacing: 0.6),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    doc.note!,
                    style: pw.TextStyle(fontSize: _body, color: muted),
                  ),
                ],
                if (doc.callToAction != null) ...[
                  pw.SizedBox(height: _gap),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: pw.BoxDecoration(color: primary, borderRadius: pw.BorderRadius.circular(10)),
                    child: pw.Text(
                      doc.callToAction!,
                      style: const pw.TextStyle(color: PdfColors.white, fontSize: _body),
                    ),
                  ),
                ],
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    doc.footer,
                    style: pw.TextStyle(fontSize: _small, color: muted),
                  ),
                ),
              ],
            ),
          ),
        );
    return pdf.save();
  }

  pw.Widget _row(DocumentRow row, PdfColor? color, PdfColor line, {bool isHeader = false}) {
    final style = pw.TextStyle(fontSize: isHeader ? _small : _body, color: color);
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 7),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: line)),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(row.label, style: style)),
          pw.Text(row.value, style: style),
        ],
      ),
    );
  }

  pw.Widget _summaryRow(DocumentRow row, PdfColor primary) {
    final style = row.isEmphasized
        ? pw.TextStyle(fontSize: _body + 2, color: primary, fontWeight: pw.FontWeight.bold)
        : const pw.TextStyle(fontSize: _body);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(row.label, style: style)),
          pw.Text(row.value, style: style),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).take(2);
    return parts.map((part) => part[0].toUpperCase()).join();
  }
}
