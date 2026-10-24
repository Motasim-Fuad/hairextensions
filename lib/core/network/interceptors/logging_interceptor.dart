import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';

/// Added to Dio only in debug builds. Logs method, path, status and duration.
class LoggingInterceptor extends Interceptor {
  static const String _source = 'Http';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[NetworkConstants.requestStartedAtKey] = DateTime.now().millisecondsSinceEpoch;
    AppLogger.debug(_source, '${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final request = response.requestOptions;
    AppLogger.debug(
      _source,
      '${response.statusCode} ${request.method} ${request.path} ${_elapsed(request)}ms',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    AppLogger.warning(
      _source,
      '${err.response?.statusCode ?? err.type.name} ${request.method} ${request.path} ${_elapsed(request)}ms',
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions request) {
    final startedAt = request.extra[NetworkConstants.requestStartedAtKey] as int?;
    if (startedAt == null) {
      return 0;
    }
    return DateTime.now().millisecondsSinceEpoch - startedAt;
  }
}
