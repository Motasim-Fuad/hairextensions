import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_month_summary.dart';

abstract interface class QuoteServerOperations {
  Future<Either<Failure, Quote>> preview(Quote quote);
  Future<Either<Failure, Quote>> duplicate(String id);
  Future<Either<Failure, Quote>> updateStatus(String id, String status);
  Future<Either<Failure, QuoteMonthSummary>> dashboard(DateTime month);
}
