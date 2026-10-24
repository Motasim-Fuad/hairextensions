import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/json_parser.dart';
import 'package:hairextensions/core/network/mappers/dio_error_mapper.dart';
import 'package:injectable/injectable.dart';

/// Thin Dio wrapper. Never throws; every call resolves to an [ApiResponse].
/// Set parseInBackground for large payloads to keep parsing off the UI isolate.
@lazySingleton
class ApiClient {
  ApiClient(this._dio);

  static const String _source = 'ApiClient';

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    required JsonParser<T> parser,
    Map<String, Object?>? query,
    CancelToken? cancelToken,
    bool parseInBackground = false,
  }) {
    return _send(
      () => _dio.get<Object?>(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
      ),
      parser,
      parseInBackground: parseInBackground,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    required JsonParser<T> parser,
    Object? body,
    Map<String, Object?>? query,
    CancelToken? cancelToken,
    bool parseInBackground = false,
  }) {
    return _send(
      () => _dio.post<Object?>(
        path,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
      ),
      parser,
      parseInBackground: parseInBackground,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    required JsonParser<T> parser,
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _send(
      () => _dio.put<Object?>(path, data: body, cancelToken: cancelToken),
      parser,
      parseInBackground: false,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    required JsonParser<T> parser,
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _send(
      () => _dio.patch<Object?>(path, data: body, cancelToken: cancelToken),
      parser,
      parseInBackground: false,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    required JsonParser<T> parser,
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _send(
      () => _dio.delete<Object?>(path, data: body, cancelToken: cancelToken),
      parser,
      parseInBackground: false,
    );
  }

  Future<ApiResponse<T>> _send<T>(
    Future<Response<Object?>> Function() request,
    JsonParser<T> parser, {
    required bool parseInBackground,
  }) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (exception) {
      return DioErrorMapper.toResponse<T>(exception);
    }
    try {
      final body = response.data;
      final data = parseInBackground ? await compute(parser, body) : parser(body);
      return ApiResponse.success(data, statusCode: response.statusCode);
    } on Object catch (error) {
      AppLogger.error(
        _source,
        'parse failed ${response.requestOptions.path}',
        error,
      );
      return ApiResponse.failure(
        statusCode: response.statusCode,
        error: error,
        errorType: ApiErrorType.parsing,
      );
    }
  }
}
