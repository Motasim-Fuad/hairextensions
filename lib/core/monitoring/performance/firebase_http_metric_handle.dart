import 'package:firebase_performance/firebase_performance.dart';
import 'package:hairextensions/core/monitoring/performance/http_metric_handle.dart';

class FirebaseHttpMetricHandle implements HttpMetricHandle {
  FirebaseHttpMetricHandle(this._metric);

  final HttpMetric _metric;
  bool _stopped = false;

  @override
  void putAttribute(String name, String value) => _metric.putAttribute(name, value);

  @override
  void setResponse({int? statusCode, int? payloadBytes, String? contentType}) {
    _metric
      ..httpResponseCode = statusCode
      ..responsePayloadSize = payloadBytes
      ..responseContentType = contentType;
  }

  @override
  Future<void> stop() async {
    if (_stopped) {
      return;
    }
    _stopped = true;
    await _metric.stop();
  }
}
