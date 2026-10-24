import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';

/// Renders a document to PDF and hands it to the system share sheet.
abstract interface class QuoteDocumentSharer {
  Future<Either<Failure, Unit>> share(QuoteDocument document);
}
