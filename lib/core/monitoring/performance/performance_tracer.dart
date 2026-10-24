import 'package:hairextensions/core/monitoring/performance/http_metric_handle.dart';
import 'package:hairextensions/core/monitoring/performance/trace_handle.dart';

/// Returns no-op handles while Firebase is unavailable, so callers never
/// branch on monitoring state.
abstract interface class PerformanceTracer {
  Future<void> setCollectionEnabled({required bool enabled});

  Future<TraceHandle> startTrace(String name);

  Future<HttpMetricHandle> startHttpMetric(String url, String method);
}
