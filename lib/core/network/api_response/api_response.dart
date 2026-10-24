import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/http_status_codes.dart';

/// Uniform result of every remote call, real or mock.
class ApiResponse<T> {
  const ApiResponse({
    required this.isSuccess,
    this.statusCode,
    this.message,
    this.data,
    this.error,
    this.errorType = ApiErrorType.none,
    this.fieldErrors = const {},
  });

  factory ApiResponse.success(
    T data, {
    int? statusCode = HttpStatusCodes.ok,
    String? message,
  }) {
    return ApiResponse(
      isSuccess: true,
      statusCode: statusCode,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.failure({
    int? statusCode,
    String? message,
    Object? error,
    ApiErrorType errorType = ApiErrorType.badResponse,
    Map<String, String> fieldErrors = const {},
  }) {
    return ApiResponse(
      isSuccess: false,
      statusCode: statusCode,
      message: message,
      error: error,
      errorType: errorType,
      fieldErrors: fieldErrors,
    );
  }

  final bool isSuccess;
  final int? statusCode;
  final String? message;
  final T? data;
  final Object? error;
  final ApiErrorType errorType;
  final Map<String, String> fieldErrors;

  bool get isFailure => !isSuccess;
  bool get hasData => data != null;
  bool get isUnauthorized => statusCode == HttpStatusCodes.unauthorized;
  bool get isForbidden => statusCode == HttpStatusCodes.forbidden;
  bool get isNotFound => statusCode == HttpStatusCodes.notFound;
  bool get isConflict => statusCode == HttpStatusCodes.conflict;
  bool get isValidationError =>
      statusCode == HttpStatusCodes.unprocessableEntity || statusCode == HttpStatusCodes.badRequest;
  bool get isRateLimited => statusCode == HttpStatusCodes.tooManyRequests;
  bool get isNetworkError => errorType == ApiErrorType.network;
  bool get isTimeout => errorType == ApiErrorType.timeout;
  bool get isCancelled => errorType == ApiErrorType.cancelled;

  bool get isClientError {
    final code = statusCode;
    return code != null && code >= HttpStatusCodes.clientErrorStart && code < HttpStatusCodes.serverErrorStart;
  }

  bool get isServerError {
    final code = statusCode;
    return code != null && code >= HttpStatusCodes.serverErrorStart && code <= HttpStatusCodes.serverErrorEnd;
  }

  /// True when retrying later can succeed (connectivity, timeouts, 5xx, 429, 408).
  bool get isTransient =>
      isNetworkError || isTimeout || isServerError || isRateLimited || statusCode == HttpStatusCodes.requestTimeout;

  ApiResponse<R> map<R>(R Function(T data) transform) {
    final value = data;
    if (isSuccess && value != null) {
      return ApiResponse.success(
        transform(value),
        statusCode: statusCode,
        message: message,
      );
    }
    return ApiResponse.failure(
      statusCode: statusCode,
      message: message,
      error: error,
      errorType: errorType,
      fieldErrors: fieldErrors,
    );
  }
}
