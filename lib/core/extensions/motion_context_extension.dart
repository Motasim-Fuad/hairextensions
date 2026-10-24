import 'package:flutter/widgets.dart';

extension MotionContextExtension on BuildContext {
  /// True when the user asked the OS to reduce or remove animations.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}
