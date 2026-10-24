part of 'screen_load_tracer.dart';

class _ScreenLoadTracerState extends State<ScreenLoadTracer> {
  TraceHandle? _trace;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  @override
  void didUpdateWidget(ScreenLoadTracer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoaded && !oldWidget.isLoaded) {
      unawaited(_finish(TraceNames.outcomeLoaded));
    }
  }

  @override
  void dispose() {
    unawaited(_finish(TraceNames.outcomeLeft));
    super.dispose();
  }

  Future<void> _start() async {
    final trace = await getIt<PerformanceTracer>().startTrace(
      TraceNames.screen(widget.feature.analyticsName, widget.screen),
    );
    trace.putAttribute(TraceNames.featureAttribute, widget.feature.analyticsName);
    _trace = trace;
    if (_finished) {
      await trace.stop();
    } else if (widget.isLoaded) {
      await _finish(TraceNames.outcomeLoaded);
    }
  }

  Future<void> _finish(String outcome) async {
    if (_finished) {
      return;
    }
    _finished = true;
    final trace = _trace;
    if (trace == null) {
      return;
    }
    trace.putAttribute(TraceNames.outcomeAttribute, outcome);
    await trace.stop();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
