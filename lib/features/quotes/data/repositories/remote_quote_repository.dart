import 'package:hairextensions/features/quotes/domain/repositories/quote_server_operations.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_month_summary.dart';
import 'package:hairextensions/core/utils/money_codec.dart';

import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/features/quotes/data/mappers/quote_api_mapper.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';
import 'package:injectable/injectable.dart';

/// Quotes and invoices served by `/v1/quotes` and `/v1/invoices`.
///
/// The server is the source of truth and prices every quote. The list is kept
/// in memory and re-read after each change; a single quote is fetched in full
/// when its screen opens. A quote that was converted keeps working under its
/// old id: reading it follows the link to the invoice.
@LazySingleton(as: QuoteRepository, env: DiEnv.remote)
class RemoteQuoteRepository implements QuoteRepository, QuoteServerOperations {
  RemoteQuoteRepository(this._client, this._tokens, this._profiles);

  static const String _source = 'QuoteRepository';
  static const String _quotes = '${NetworkConstants.apiPrefix}/quotes';
  static const String _invoices = '${NetworkConstants.apiPrefix}/invoices';
  static const String _business = '${NetworkConstants.apiPrefix}/business';
  static const int _pageSize = 100;
  static const int _numberDigits = 4;

  final ApiClient _client;
  final SecureTokenStore _tokens;
  final BusinessProfileReader _profiles;
  final StreamController<List<Quote>> _listChanges =
      StreamController<List<Quote>>.broadcast();
  final StreamController<_QuoteEvent> _events =
      StreamController<_QuoteEvent>.broadcast();
  List<Quote>? _list;
  String? _loadedForToken;
  Future<void>? _listLoading;
  Json? _businessCache;

  @override
  Future<Either<Failure, Quote>> preview(Quote quote) async {
    final body = QuoteApiMapper.quoteToApi(quote);
    final response = await _client.post<Quote>(
      '$_quotes/preview',
      body: {
        for (final key in ['lines', 'deposit', 'tax_rate_percent'])
          key: body[key],
      },
      parser: (json) => QuoteApiMapper.previewFromApi(json! as Json, quote),
    );
    return response.isSuccess && response.data != null
        ? Right(response.data!)
        : Left(ApiFailureMapper.toFailure(response));
  }

  @override
  Future<Either<Failure, Quote>> duplicate(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null || ref.isInvoice)
      return const Left(
        ValidationFailure(message: 'Select a quote to duplicate.'),
      );
    final response = await _client.post<Quote>(
      '$_quotes/${ref.id}/duplicate',
      parser: _parseQuote,
    );
    if (!response.isSuccess || response.data == null)
      return Left(ApiFailureMapper.toFailure(response));
    _businessCache = null;
    unawaited(_refreshList());
    return Right(response.data!);
  }

  @override
  Future<Either<Failure, Quote>> updateStatus(String id, String status) async {
    final ref = _Ref.tryParse(id);
    if (ref == null)
      return const Left(ValidationFailure(message: 'Save the document first.'));
    final response = await _client.patch<Quote>(
      '${ref.isInvoice ? _invoices : _quotes}/${ref.id}/status',
      body: {'status': status},
      parser: ref.isInvoice ? _parseInvoice : _parseQuote,
    );
    if (!response.isSuccess || response.data == null)
      return Left(ApiFailureMapper.toFailure(response));
    _publish(id, response.data);
    unawaited(_refreshList());
    return Right(response.data!);
  }

  @override
  Future<Either<Failure, QuoteMonthSummary>> dashboard(DateTime month) async {
    String date(DateTime value) => value.toIso8601String().substring(0, 10);
    final response = await _client.get<QuoteMonthSummary>(
      '/v1/dashboard',
      query: {
        'date_from': date(DateTime(month.year, month.month)),
        'date_to': date(DateTime(month.year, month.month + 1, 0)),
      },
      parser: (json) {
        final period = (json! as Json)['period'] as Json;
        return QuoteMonthSummary(
          month: month,
          quotedMinor: MoneyCodec.toMinor(period['quoted_value']),
          quoteCount: (period['quotes_created'] as num).toInt(),
          invoiceCount: (period['invoices_issued'] as num).toInt(),
          depositsMinor: MoneyCodec.toMinor(period['collected']),
          profitPerHourMinor: period['profit_per_hour'] == null
              ? null
              : MoneyCodec.toMinor(period['profit_per_hour']),
        );
      },
    );
    return response.isSuccess && response.data != null
        ? Right(response.data!)
        : Left(ApiFailureMapper.toFailure(response));
  }

  // ------------------------------------------------------------- watching

  @override
  Stream<List<Quote>> watchAll() async* {
    _resetForNewAccount();
    yield _list ?? const [];
    unawaited(_refreshList());
    yield* _listChanges.stream;
  }

  @override
  Stream<Quote?> watch(String id) async* {
    _resetForNewAccount();
    final loaded = await _fetch(id);
    yield loaded.match((failure) => throw failure, (quote) => quote);
    yield* _events.stream
        .where((event) => event.forId == id)
        .map((event) => event.quote);
  }

  // -------------------------------------------------------------- numbers

  /// The server assigns the real number on save. This is the next one it will
  /// hand out, shown while the quote is still being built.
  @override
  Future<Either<Failure, String>> nextNumber(QuoteStatus status) async {
    var business = _businessCache;
    if (business == null) {
      final response = await _client.get<Json>(
        _business,
        parser: (json) => json! as Json,
      );
      business = response.data;
      if (!response.isSuccess || business == null) {
        final local = await _profiles.read();
        if (local == null) {
          return Left(ApiFailureMapper.toFailure(response));
        }
        final isInvoice = status.isInvoice;
        final prefix = (isInvoice ? local.invoicePrefix : local.quotePrefix)
            .toUpperCase()
            .replaceAll(RegExp('[^A-Z0-9]'), '');
        final next = isInvoice
            ? local.nextInvoiceNumber
            : local.nextQuoteNumber;
        return Right('$prefix${next.toString().padLeft(_numberDigits, '0')}');
      }
      _businessCache = business;
    }
    final isInvoice = status.isInvoice;
    final prefix =
        business[isInvoice ? 'invoice_prefix' : 'quote_prefix'] as String? ??
        '';
    final next =
        (business[isInvoice ? 'next_invoice_number' : 'next_quote_number']
                as num?)
            ?.toInt() ??
        1;
    return Right('$prefix${next.toString().padLeft(_numberDigits, '0')}');
  }

  // ---------------------------------------------------------------- write

  @override
  Future<Either<Failure, Quote>> save(Quote quote) async {
    final ref = _Ref.tryParse(quote.id);
    if (ref != null && ref.isInvoice) {
      return const Left(
        ValidationFailure(
          message: 'An invoice cannot be edited. Create a new quote instead.',
        ),
      );
    }
    final body = QuoteApiMapper.quoteToApi(quote);
    final ApiResponse<Quote> response = ref == null
        ? await _client.post(_quotes, body: body, parser: _parseQuote)
        : await _client.patch(
            '$_quotes/${ref.id}',
            body: body,
            parser: _parseQuote,
          );
    final saved = response.data;
    if (!response.isSuccess || saved == null) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _businessCache = null;
    if (ref == null && quote.status.isInvoice) {
      final invoice = await _invoiceFor(saved.id, previousId: quote.id);
      return invoice;
    }
    _publish(quote.id, saved);
    if (saved.id != quote.id) {
      _publish(saved.id, saved);
    }
    return Right(saved);
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null) {
      return const Right(unit);
    }
    final path = ref.isInvoice ? '$_invoices/${ref.id}' : '$_quotes/${ref.id}';
    final response = await _client.delete<void>(path, parser: (_) {});
    if (!response.isSuccess && !response.isNotFound) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _businessCache = null;
    _publish(id, null);
    unawaited(_refreshList());
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Quote>> convertToInvoice(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null || ref.isInvoice) {
      return const Left(
        ValidationFailure(
          message: 'Only a quote can be turned into an invoice.',
        ),
      );
    }
    return _invoiceFor(id, previousId: id);
  }

  @override
  Future<Either<Failure, Quote>> markPaid(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null || !ref.isInvoice) {
      return const Left(
        ValidationFailure(message: 'Only an invoice can be marked as paid.'),
      );
    }
    final response = await _client.patch<Quote>(
      '$_invoices/${ref.id}/status',
      body: {'status': 'paid'},
      parser: _parseInvoice,
    );
    final invoice = response.data;
    if (!response.isSuccess || invoice == null) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _publish(id, invoice);
    unawaited(_refreshList());
    return Right(invoice);
  }

  /// Marks a quote as sent. A quote that is already sent, accepted or invoiced
  /// answers 409, which is fine here: the share itself already happened.
  @override
  Future<Either<Failure, Unit>> recordShare(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null || ref.isInvoice) {
      return const Right(unit);
    }
    final response = await _client.patch<Quote>(
      '$_quotes/${ref.id}/status',
      body: {'status': 'sent'},
      parser: _parseQuote,
    );
    final updated = response.data;
    if (response.isSuccess && updated != null) {
      _publish(id, updated);
      return const Right(unit);
    }
    if (response.isConflict) {
      return const Right(unit);
    }
    return Left(ApiFailureMapper.toFailure(response));
  }

  // -------------------------------------------------------------- helpers

  Future<Either<Failure, Quote>> _invoiceFor(
    String quoteId, {
    required String previousId,
  }) async {
    final ref = _Ref.tryParse(quoteId)!;
    final response = await _client.post<Quote>(
      '$_quotes/${ref.id}/invoice',
      body: const <String, Object?>{},
      parser: _parseInvoice,
    );
    final invoice = response.data;
    if (!response.isSuccess || invoice == null) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _businessCache = null;
    _publish(previousId, invoice);
    _publish(quoteId, invoice);
    unawaited(_refreshList());
    return Right(invoice);
  }

  Future<Either<Failure, Quote?>> _fetch(String id) async {
    final ref = _Ref.tryParse(id);
    if (ref == null) {
      return const Right(null);
    }
    if (ref.isInvoice) {
      final response = await _client.get<Quote>(
        '$_invoices/${ref.id}',
        parser: _parseInvoice,
      );
      return _asResult(response);
    }
    final response = await _client.get<Json>(
      '$_quotes/${ref.id}',
      parser: (json) => json! as Json,
    );
    final json = response.data;
    if (!response.isSuccess || json == null) {
      return _asResult(response.map<Quote>(QuoteApiMapper.quoteFromApi));
    }
    final invoiceId = (json['invoice_id'] as num?)?.toInt();
    if (QuoteApiMapper.isInvoiced(json) && invoiceId != null) {
      final invoice = await _client.get<Quote>(
        '$_invoices/$invoiceId',
        parser: _parseInvoice,
      );
      return _asResult(invoice);
    }
    return Right(QuoteApiMapper.quoteFromApi(json));
  }

  Either<Failure, Quote?> _asResult(ApiResponse<Quote> response) {
    if (response.isSuccess) {
      return Right(response.data);
    }
    if (response.isNotFound) {
      return const Right(null);
    }
    return Left(ApiFailureMapper.toFailure(response));
  }

  void _publish(String forId, Quote? quote) {
    _events.add(_QuoteEvent(forId, quote));
    unawaited(_refreshList());
  }

  void _resetForNewAccount() {
    final token = _tokens.cachedAccessToken;
    if (token != _loadedForToken) {
      _loadedForToken = token;
      _list = null;
      _listLoading = null;
      _businessCache = null;
    }
  }

  Future<void> _refreshList() =>
      _listLoading ??= _loadList().whenComplete(() => _listLoading = null);

  Future<void> _loadList() async {
    final quotes = await _loadAll(_quotes);
    final invoices = await _loadAll(_invoices);
    if (quotes == null || invoices == null) {
      AppLogger.warning(_source, 'list load failed');
      return;
    }
    final merged = <Quote>[
      for (final quote in quotes)
        if (!QuoteApiMapper.isInvoiced(quote))
          QuoteApiMapper.quoteFromSummary(quote),
      for (final invoice in invoices)
        QuoteApiMapper.invoiceFromSummary(invoice),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _list = merged;
    _listChanges.add(merged);
  }

  Future<List<Json>?> _loadAll(String path) async {
    final all = <Json>[];
    var offset = 0;
    while (true) {
      final response = await _client.get<Json>(
        path,
        query: {'limit': _pageSize, 'offset': offset},
        parser: (json) => json! as Json,
      );
      final page = response.data;
      if (!response.isSuccess || page == null) {
        return null;
      }
      final items = [
        for (final item in page['items'] as List<dynamic>) item as Json,
      ];
      all.addAll(items);
      offset += items.length;
      if (items.isEmpty || offset >= (page['total'] as num).toInt()) {
        return all;
      }
    }
  }

  static Quote _parseQuote(Object? json) =>
      QuoteApiMapper.quoteFromApi(json! as Json);

  static Quote _parseInvoice(Object? json) =>
      QuoteApiMapper.invoiceFromApi(json! as Json);
}

/// `q12` is quote 12, `i7` is invoice 7; anything else is a draft id the app
/// generated locally and the server has not seen yet.
class _Ref {
  const _Ref({required this.isInvoice, required this.id});

  static _Ref? tryParse(String value) {
    if (value.length < 2) {
      return null;
    }
    final isInvoice = value.startsWith(QuoteApiMapper.invoicePrefix);
    if (!isInvoice && !value.startsWith(QuoteApiMapper.quotePrefix)) {
      return null;
    }
    final id = int.tryParse(value.substring(1));
    return id == null ? null : _Ref(isInvoice: isInvoice, id: id);
  }

  final bool isInvoice;
  final int id;
}

class _QuoteEvent {
  const _QuoteEvent(this.forId, this.quote);

  final String forId;
  final Quote? quote;
}
