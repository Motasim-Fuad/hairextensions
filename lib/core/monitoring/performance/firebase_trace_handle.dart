import 'package:firebase_performance/firebase_performance.dart';
import 'package:hairextensions/core/monitoring/performance/trace_handle.dart';

class FirebaseTraceHandle implements TraceHandle {
  FirebaseTraceHandle(this._trace);

  final Trace _trace;
  bool _stopped = false;

  @override
  void putAttribute(String name, String value) => _trace.putAttribute(name, value);

  @override
  void setMetric(String name, int value) => _trace.setMetric(name, value);

  @override
  void incrementMetric(String name, [int by = 1]) => _trace.incrementMetric(name, by);

  @override
  Future<void> stop() async {
    if (_stopped) {
      return;
    }
    _stopped = true;
    await _trace.stop();
  }
}
