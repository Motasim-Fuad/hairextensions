import 'package:flutter/painting.dart';

/// Every raw color in the app. The four brand colors come from the client's
/// brand guide; the rest are tints, shades and neutrals derived from them (or
/// functional colors such as success and danger). To rebrand, change the brand
/// block and its ramp; everything else in the UI reads these through AppColors.
abstract final class BrandPalette {
  // Brand colors (client brand guide).
  /// Baby Pink #FFCBDB: soft fills, selected states, highlights.
  static const Color babyPink = Color(0xFFFFCBDB);

  /// Vibrant Pink #ED77A8: the primary action color.
  static const Color vibrantPink = Color(0xFFED77A8);

  /// Charcoal Grey #63635D: main text and icons.
  static const Color charcoal = Color(0xFF63635D);

  /// White #FFFFFF: cards, sheets and text on pink.
  static const Color white = Color(0xFFFFFFFF);

  // Primary ramp, built on Vibrant Pink.
  static const Color primary = vibrantPink;

  /// Darker Vibrant Pink for text-sized pink (links, pressed states). Vibrant
  /// Pink itself is only 2.7:1 on white; this is 5.7:1.
  static const Color primaryDeep = Color(0xFFB03A6B);
  static const Color primaryGradientStart = Color(0xFFF08DB5);
  static const Color primaryGradientEnd = Color(0xFFD45B91);
  static const Color primarySoft = babyPink;
  static const Color primaryWash = Color(0xFFFFF1F6);

  static const Color black = Color(0xFF000000);

  // Neutrals, built on Charcoal Grey.
  static const Color ink = charcoal;
  static const Color inkMuted = Color(0xFF72726C);
  static const Color inkSubtle = Color(0xFF8F8F89);
  static const Color canvas = Color(0xFFFFF8FB);
  static const Color line = Color(0xFFF3E4EA);
  static const Color lineStrong = Color(0xFFD3C4CA);

  // "Premium" accent (Pro badges, crown). The brand guide has no gold, so it
  // follows Charcoal Grey.
  static const Color gold = charcoal;
  static const Color goldDeep = Color(0xFF4A4A45);
  static const Color goldSoft = Color(0xFFF1F1EF);

  // Functional colors.
  static const Color success = Color(0xFF1E9E6A);
  static const Color successSoft = Color(0xFFE3F5EC);
  static const Color warning = Color(0xFFB98A0E);
  static const Color danger = Color(0xFFD93636);

  // Dark mode neutrals, tinted toward Charcoal Grey.
  static const Color darkCanvas = Color(0xFF1A1A18);
  static const Color darkSurface = Color(0xFF262624);
  static const Color darkLine = Color(0xFF3A3A37);
  static const Color darkInk = Color(0xFFF4F4F2);
  static const Color darkInkMuted = Color(0xFFA5A5A0);
}
