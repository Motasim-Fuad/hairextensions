import 'package:dio/dio.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/monitoring/performance/http_metric_handle.dart';
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart';
import 'package:hairextensions/core/monitoring/performance/trace_names.dart';

/// Firebase only auto-instruments native HTTP stacks, so Dio calls are traced
/// here. Query strings are dropped to keep URLs free of personal data.
class PerformanceInterceptor extends Interceptor {
  PerformanceInterceptor(this._tracer);

  final PerformanceTracer _tracer;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final url = options.uri.replace(query: '').toString();
    final metric = await _tracer.startHttpMetric(url, options.method);
    final feature = options.extra[NetworkConstants.featureKey];
    if (feature is String) {
      metric.putAttribute(TraceNames.featureAttribute, feature);
    }
    options.extra[NetworkConstants.httpMetricKey] = metric;
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    await _finish(response.requestOptions, response);
    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    await _finish(err.requestOptions, err.response);
    handler.next(err);
  }

  Future<void> _finish(RequestOptions options, Response<dynamic>? response) async {
    final metric = options.extra.remove(NetworkConstants.httpMetricKey);
    if (metric is! HttpMetricHandle) {
      return;
    }
    final length = response?.headers.value(Headers.contentLengthHeader);
    metric.setResponse(
      statusCode: response?.statusCode,
      payloadBytes: length == null ? null : int.tryParse(length),
      contentType: response?.headers.value(Headers.contentTypeHeader),
    );
    await metric.stop();
  }
}
