import 'package:flutter/painting.dart';
import 'package:hairextensions/core/theme/tokens/app_typography.dart';

/// Named text styles from the Figma file. They carry no color; widgets apply
/// one from context.colors.
abstract final class AppTextStyles {
  static const double _overlineSpacing = 0.66;
  static const double _onboardingLineHeight = 38 / 32;
  static const double _paragraphLineHeight = 22 / 15;

  static const TextStyle logoMark = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 60,
  );

  /// The Amna Sheen signature wordmark. Falls back to italic Playfair Display
  /// until the signature font file is added (see AppTypography.logoFamily).
  static const TextStyle logoWordmark = TextStyle(
    fontFamily: AppTypography.logoFamily,
    fontFamilyFallback: AppTypography.logoFallback,
    fontStyle: FontStyle.italic,
    fontSize: 44,
    height: 1.1,
  );

  static const TextStyle heroAmount = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 42,
  );

  static const TextStyle splashTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 38,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 32,
    height: _onboardingLineHeight,
  );

  static const TextStyle highlightAmount = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 26,
  );

  static const TextStyle displayName = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 24,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 22,
  );

  static const TextStyle documentTitle = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 18,
  );

  static const TextStyle monogram = TextStyle(
    fontFamily: AppTypography.displayFamily,
    fontWeight: AppTypography.displayWeight,
    fontVariations: AppTypography.displayVariations,
    fontFeatures: AppTypography.displayFeatures,
    fontSize: 15,
  );

  static final TextStyle sectionTitle = _body(20, FontWeight.w700);
  static final TextStyle button = _body(16, FontWeight.w700);
  static final TextStyle planTitle = _body(16, FontWeight.w700);
  static final TextStyle rowTitle = _body(15, FontWeight.w700);
  static final TextStyle action = _body(15, FontWeight.w600);
  static final TextStyle feature = _body(15, FontWeight.w500);
  static final TextStyle paragraph = _body(15, FontWeight.w400).copyWith(height: _paragraphLineHeight);
  static final TextStyle lead = _body(15, FontWeight.w400);
  static final TextStyle link = _body(14, FontWeight.w700);
  static final TextStyle rowLabel = _body(14, FontWeight.w600);
  static final TextStyle rowValue = _body(14, FontWeight.w700);
  static final TextStyle detail = _body(13, FontWeight.w500);
  static final TextStyle detailStrong = _body(13, FontWeight.w700);
  static final TextStyle detailAccent = _body(13, FontWeight.w600);
  static final TextStyle greeting = _body(13, FontWeight.w500);
  static final TextStyle chip = _body(12, FontWeight.w700);
  static final TextStyle caption = _body(12, FontWeight.w500);
  static final TextStyle captionStrong = _body(12, FontWeight.w600);
  static final TextStyle overline = _body(11, FontWeight.w600).copyWith(letterSpacing: _overlineSpacing);
  static final TextStyle navLabel = _body(11, FontWeight.w500);
  static final TextStyle navLabelSelected = _body(11, FontWeight.w700);
  static final TextStyle micro = _body(10, FontWeight.w500);

  static TextStyle _body(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: AppTypography.bodyFamily,
      fontFamilyFallback: AppTypography.bodyFallback,
      fontSize: size,
      fontWeight: weight,
      fontVariations: [FontVariation.weight(weight.value.toDouble())],
    );
  }
}
