import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/quotes/data/demo/demo_quotes.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity_type.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:injectable/injectable.dart';

/// In-memory quotes seeded with sample data so every screen can be demoed.
/// Swap for a sqflite-backed implementation without touching presentation.
@LazySingleton(as: QuoteRepository)
class DemoQuoteRepository implements QuoteRepository {
  DemoQuoteRepository(this._clock) : _quotes = DemoQuotes.build(_clock.now());

  static const String _quotePrefix = 'Q-';
  static const String _invoicePrefix = 'INV-';
  static const int _numberDigits = 4;

  final Clock _clock;
  final StreamController<List<Quote>> _changes = StreamController<List<Quote>>.broadcast();
  List<Quote> _quotes;
  int _nextQuote = DemoQuotes.nextQuoteNumber;
  int _nextInvoice = DemoQuotes.nextInvoiceNumber;

  @override
  Stream<List<Quote>> watchAll() async* {
    yield _quotes;
    yield* _changes.stream;
  }

  @override
  Stream<Quote?> watch(String id) => watchAll().map((quotes) => quotes.where((quote) => quote.id == id).firstOrNull);

  @override
  Future<Either<Failure, String>> nextNumber(QuoteStatus status) async {
    return Right(status.isInvoice ? _format(_invoicePrefix, _nextInvoice) : _format(_quotePrefix, _nextQuote));
  }

  @override
  Future<Either<Failure, Quote>> save(Quote quote) async {
    final isNew = _quotes.every((existing) => existing.id != quote.id);
    if (isNew) {
      if (quote.status.isInvoice) {
        _nextInvoice++;
      } else {
        _nextQuote++;
      }
    }
    final saved = isNew
        ? quote.copyWith(
            activity: [QuoteActivity(type: QuoteActivityType.created, at: _clock.now())],
          )
        : quote;
    _publish([saved, ..._quotes.where((existing) => existing.id != quote.id)]);
    return Right(saved);
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    _publish(_quotes.where((quote) => quote.id != id).toList());
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Quote>> convertToInvoice(String id) {
    final number = _format(_invoicePrefix, _nextInvoice++);
    return _update(
      id,
      QuoteActivityType.convertedToInvoice,
      (quote) => quote.copyWith(status: QuoteStatus.invoice, number: number),
    );
  }

  @override
  Future<Either<Failure, Quote>> markPaid(String id) {
    return _update(id, QuoteActivityType.markedPaid, (quote) => quote.copyWith(status: QuoteStatus.paid));
  }

  @override
  Future<Either<Failure, Unit>> recordShare(String id) async {
    final result = await _update(id, QuoteActivityType.shared, (quote) => quote);
    return result.map((_) => unit);
  }

  Future<Either<Failure, Quote>> _update(String id, QuoteActivityType type, Quote Function(Quote) change) async {
    final current = _quotes.where((quote) => quote.id == id).firstOrNull;
    if (current == null) {
      return const Left(NotFoundFailure());
    }
    final changed = change(current);
    final updated = changed.copyWith(
      activity: [
        ...changed.activity,
        QuoteActivity(type: type, at: _clock.now()),
      ],
    );
    _publish([for (final quote in _quotes) quote.id == id ? updated : quote]);
    return Right(updated);
  }

  void _publish(List<Quote> quotes) {
    _quotes = quotes;
    _changes.add(quotes);
  }

  String _format(String prefix, int number) => '$prefix${number.toString().padLeft(_numberDigits, '0')}';
}
