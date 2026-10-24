import 'package:firebase_performance/firebase_performance.dart';
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/performance/firebase_http_metric_handle.dart';
import 'package:hairextensions/core/monitoring/performance/firebase_trace_handle.dart';
import 'package:hairextensions/core/monitoring/performance/http_metric_handle.dart';
import 'package:hairextensions/core/monitoring/performance/noop_http_metric_handle.dart';
import 'package:hairextensions/core/monitoring/performance/noop_trace_handle.dart';
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart';
import 'package:hairextensions/core/monitoring/performance/trace_handle.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PerformanceTracer)
class FirebasePerformanceTracer implements PerformanceTracer {
  FirebasePerformanceTracer(this._firebase);

  static const String _source = 'PerformanceTracer';

  final FirebaseBootstrapper _firebase;
  bool _enabled = false;

  bool get _active => _firebase.isReady && _enabled;

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {
    _enabled = enabled;
    if (_firebase.isReady) {
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(enabled);
    }
  }

  @override
  Future<TraceHandle> startTrace(String name) async {
    if (!_active) {
      return const NoopTraceHandle();
    }
    try {
      final trace = FirebasePerformance.instance.newTrace(name);
      await trace.start();
      return FirebaseTraceHandle(trace);
    } on Object catch (error) {
      AppLogger.warning(_source, 'trace $name failed $error');
      return const NoopTraceHandle();
    }
  }

  @override
  Future<HttpMetricHandle> startHttpMetric(String url, String method) async {
    final httpMethod = _httpMethodOf(method);
    if (!_active || httpMethod == null) {
      return const NoopHttpMetricHandle();
    }
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(url, httpMethod);
      await metric.start();
      return FirebaseHttpMetricHandle(metric);
    } on Object catch (error) {
      AppLogger.warning(_source, 'http metric failed $error');
      return const NoopHttpMetricHandle();
    }
  }

  HttpMethod? _httpMethodOf(String method) {
    final upper = method.toUpperCase();
    for (final value in HttpMethod.values) {
      if (value.name.toUpperCase() == upper) {
        return value;
      }
    }
    return null;
  }
}
