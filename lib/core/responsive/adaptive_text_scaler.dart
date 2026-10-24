import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/responsive/window_size_class.dart';

/// Respects the user's text size while keeping layouts intact, and gives
/// tablets a slightly larger base size.
abstract final class AdaptiveTextScaler {
  static const double minScale = 0.85;
  static const double maxScale = 1.6;
  static const double _tabletBoost = 1.08;

  static TextScaler resolve(MediaQueryData data) {
    final clamped = data.textScaler.clamp(
      minScaleFactor: minScale,
      maxScaleFactor: maxScale,
    );
    final sizeClass = WindowSizeClass.fromWidth(data.size.shortestSide);
    if (sizeClass == WindowSizeClass.compact) {
      return clamped;
    }
    return TextScaler.linear(
      (clamped.scale(1) * _tabletBoost).clamp(minScale, maxScale),
    );
  }
}
