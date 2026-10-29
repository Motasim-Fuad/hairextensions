import 'dart:math';

import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/http_status_codes.dart';

/// Retries idempotent requests on transient failures with exponential backoff
/// and jitter. Non-idempotent writes are never replayed here; the offline sync
/// queue owns their retries.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this._dio, Random? random})
    : _random = random ?? Random();

  static const String _source = 'RetryInterceptor';
  static const Set<String> _idempotentMethods = {
    'GET',
    'HEAD',
    'OPTIONS',
    'PUT',
    'DELETE',
  };

  final Dio _dio;
  final Random _random;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final attempt =
        request.extra[NetworkConstants.retryAttemptKey] as int? ?? 0;
    if (attempt >= NetworkConstants.maxRetries || !_isRetryable(err)) {
      handler.next(err);
      return;
    }
    await Future<void>.delayed(_delayFor(attempt));
    if (request.cancelToken?.isCancelled ?? false) {
      handler.next(err);
      return;
    }
    AppLogger.debug(
      _source,
      'retry ${attempt + 1} ${request.method} ${request.path}',
    );
    try {
      final response = await _dio.fetch<Object?>(
        request.copyWith(
          data: request.data is FormData
              ? (request.data as FormData).clone()
              : request.data,
          extra: {
            ...request.extra,
            NetworkConstants.retryAttemptKey: attempt + 1,
          },
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    if (!_idempotentMethods.contains(err.requestOptions.method.toUpperCase())) {
      return false;
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        return status == HttpStatusCodes.tooManyRequests ||
            (status >= HttpStatusCodes.serverErrorStart &&
                status != HttpStatusCodes.notImplemented);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }

  Duration _delayFor(int attempt) {
    final baseMs = NetworkConstants.retryBaseDelay.inMilliseconds;
    final exponential = baseMs * pow(2, attempt).toInt();
    final jitter = _random.nextInt(baseMs);
    final capped = min(
      exponential + jitter,
      NetworkConstants.retryMaxDelay.inMilliseconds,
    );
    return Duration(milliseconds: capped);
  }
}
