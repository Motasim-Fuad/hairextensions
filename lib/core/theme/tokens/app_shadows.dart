import 'package:flutter/painting.dart';
import 'package:hairextensions/core/theme/brand_palette.dart';

/// Shadows are cheap single-layer blurs. Avoid them inside long lists.
abstract final class AppShadows {
  static const double _cardAlpha = 0.06;
  static const double _floatingAlpha = 0.22;
  static const double _showcaseAlpha = 0.18;
  static const double _navAlpha = 0.08;
  static const double _logoAlpha = 0.18;

  static final List<BoxShadow> card = [
    BoxShadow(
      color: BrandPalette.ink.withValues(alpha: _cardAlpha),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> floating = [
    BoxShadow(
      color: BrandPalette.primary.withValues(alpha: _floatingAlpha),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> showcase = [
    BoxShadow(
      color: BrandPalette.primary.withValues(alpha: _showcaseAlpha),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> bottomNav = [
    BoxShadow(
      color: BrandPalette.ink.withValues(alpha: _navAlpha),
      blurRadius: 24,
      offset: const Offset(0, -6),
    ),
  ];

  static final List<BoxShadow> logo = [
    BoxShadow(
      color: BrandPalette.black.withValues(alpha: _logoAlpha),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];
}
