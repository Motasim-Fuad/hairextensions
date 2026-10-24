import 'package:hairextensions/core/monitoring/performance/trace_handle.dart';

class NoopTraceHandle implements TraceHandle {
  const NoopTraceHandle();

  @override
  void putAttribute(String name, String value) {}

  @override
  void setMetric(String name, int value) {}

  @override
  void incrementMetric(String name, [int by = 1]) {}

  @override
  Future<void> stop() async {}
}
