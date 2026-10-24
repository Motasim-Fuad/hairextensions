import 'package:flutter/widgets.dart';

/// Moves the shimmer gradient horizontally by a fraction of the painted width.
class SlidingGradientTransform extends GradientTransform {
  const SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
