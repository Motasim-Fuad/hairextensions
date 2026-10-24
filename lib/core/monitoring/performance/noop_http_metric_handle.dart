import 'package:hairextensions/core/monitoring/performance/http_metric_handle.dart';

class NoopHttpMetricHandle implements HttpMetricHandle {
  const NoopHttpMetricHandle();

  @override
  void putAttribute(String name, String value) {}

  @override
  void setResponse({int? statusCode, int? payloadBytes, String? contentType}) {}

  @override
  Future<void> stop() async {}
}
