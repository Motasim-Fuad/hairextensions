import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';

abstract interface class QuoteRepository {
  /// Newest first. Emits the current list, then every change.
  Stream<List<Quote>> watchAll();

  /// Emits null once the quote is deleted.
  Stream<Quote?> watch(String id);

  Future<Either<Failure, String>> nextNumber(QuoteStatus status);

  Future<Either<Failure, Quote>> save(Quote quote);

  Future<Either<Failure, Unit>> delete(String id);

  Future<Either<Failure, Quote>> convertToInvoice(String id);

  Future<Either<Failure, Quote>> markPaid(String id);

  Future<Either<Failure, Unit>> recordShare(String id);
}
