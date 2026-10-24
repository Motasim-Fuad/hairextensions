import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_colors.dart';

/// Brand typography: Playfair Display for main headings, Helvetica for body
/// text and smaller headings.
///
/// Helvetica is a licensed system font on iOS and macOS and is not bundled.
/// Where it is missing (Android, web, Windows, Linux) text falls back to the
/// bundled Arimo, which is metrically compatible with Helvetica, so layouts
/// stay the same on every platform.
///
/// Both bundled files are variable fonts, so weight is applied as a font
/// variation as well as a FontWeight.
abstract final class AppTypography {
  static const String displayFamily = 'PlayfairDisplay';
  static const String bodyFamily = 'Helvetica';
  static const String bodyFallbackFamily = 'Arimo';

  /// Brand signature used for the Amna Sheen wordmark. Add the font file to
  /// pubspec.yaml under this family name; until then the wordmark renders in
  /// italic Playfair Display.
  static const String logoFamily = 'AmnaSheenSignature';

  static const List<String> bodyFallback = [bodyFallbackFamily];
  static const List<String> logoFallback = [displayFamily];

  static const FontWeight displayWeight = FontWeight.w600;
  static const List<FontVariation> displayVariations = [FontVariation('wght', 600)];

  /// Playfair Display defaults to old-style numerals, which look uneven in
  /// prices and totals. Lining figures keep amounts aligned.
  static const List<FontFeature> displayFeatures = [FontFeature.liningFigures()];

  static const double _bodyHeight = 1.35;
  static const double _displayHeight = 1.2;
  static const double _overlineSpacing = 0.8;

  static TextTheme textTheme(AppColors colors) {
    return TextTheme(
      displayLarge: _display(40, colors.textPrimary),
      displayMedium: _display(34, colors.textPrimary),
      displaySmall: _display(30, colors.textPrimary),
      headlineLarge: _display(28, colors.textPrimary),
      headlineMedium: _display(24, colors.textPrimary),
      headlineSmall: _display(20, colors.textPrimary),
      titleLarge: _body(18, FontWeight.w700, colors.textPrimary),
      titleMedium: _body(16, FontWeight.w600, colors.textPrimary),
      titleSmall: _body(14, FontWeight.w600, colors.textPrimary),
      bodyLarge: _body(16, FontWeight.w400, colors.textPrimary),
      bodyMedium: _body(14, FontWeight.w400, colors.textPrimary),
      bodySmall: _body(12, FontWeight.w400, colors.textSecondary),
      labelLarge: _body(15, FontWeight.w600, colors.textPrimary),
      labelMedium: _body(13, FontWeight.w600, colors.textPrimary),
      labelSmall: _body(
        11,
        FontWeight.w700,
        colors.textSecondary,
      ).copyWith(letterSpacing: _overlineSpacing),
    );
  }

  static TextStyle _display(double size, Color color) {
    return TextStyle(
      fontFamily: displayFamily,
      fontSize: size,
      fontWeight: displayWeight,
      fontVariations: displayVariations,
      fontFeatures: displayFeatures,
      height: _displayHeight,
      color: color,
    );
  }

  static TextStyle _body(double size, FontWeight weight, Color color) {
    return TextStyle(
      fontFamily: bodyFamily,
      fontFamilyFallback: bodyFallback,
      fontSize: size,
      fontWeight: weight,
      fontVariations: [FontVariation.weight(weight.value.toDouble())],
      height: _bodyHeight,
      color: color,
    );
  }
}
