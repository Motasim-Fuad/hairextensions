import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/mappers/fast_api_error_parser.dart';

abstract final class DioErrorMapper {
  static ApiResponse<T> toResponse<T>(DioException exception) {
    final body = exception.response?.data;
    return ApiResponse.failure(
      statusCode: exception.response?.statusCode,
      message: FastApiErrorParser.message(body),
      error: exception,
      errorType: _typeOf(exception),
      fieldErrors: FastApiErrorParser.fieldErrors(body),
    );
  }

  static ApiErrorType _typeOf(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => ApiErrorType.timeout,
      DioExceptionType.cancel => ApiErrorType.cancelled,
      DioExceptionType.connectionError => ApiErrorType.network,
      DioExceptionType.badCertificate => ApiErrorType.badCertificate,
      DioExceptionType.badResponse => ApiErrorType.badResponse,
      DioExceptionType.unknown => exception.error is SocketException ? ApiErrorType.network : ApiErrorType.unknown,
    };
  }
}
