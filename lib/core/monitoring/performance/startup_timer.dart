/// Measures main() to first frame. Firebase starts after the first frame, so
/// the duration is recorded later as a metric on the app_startup trace.
abstract final class StartupTimer {
  static final Stopwatch _watch = Stopwatch();
  static int? _firstFrameMs;

  static int? get firstFrameMs => _firstFrameMs;

  static void markProcessStart() {
    if (!_watch.isRunning) {
      _watch.start();
    }
  }

  static void markFirstFrame() {
    _firstFrameMs ??= _watch.elapsedMilliseconds;
    _watch.stop();
  }
}
