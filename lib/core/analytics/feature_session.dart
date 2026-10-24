import 'package:hairextensions/core/feature_flags/feature_key.dart';

/// Measures how long a feature stays in use. [end] is idempotent so it can be
/// called from both a completion path and dispose.
class FeatureSession {
  FeatureSession(this.feature, this._onEnd) : _watch = Stopwatch()..start();

  final FeatureKey feature;
  final void Function(FeatureKey feature, Duration duration) _onEnd;
  final Stopwatch _watch;
  bool _ended = false;

  bool get isActive => !_ended;

  void end() {
    if (_ended) {
      return;
    }
    _ended = true;
    _watch.stop();
    _onEnd(feature, _watch.elapsed);
  }
}
