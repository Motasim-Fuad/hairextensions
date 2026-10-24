import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/brand_palette.dart';

/// Semantic color tokens, derived from [BrandPalette]. Widgets read these via
/// context.colors and never use raw colors.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryStrong,
    required this.primarySoft,
    required this.primarySurface,
    required this.primaryBorder,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.gold,
    required this.goldSoft,
    required this.goldBorder,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.borderStrong,
    required this.goldDeep,
    required this.heroStart,
    required this.heroEnd,
  });

  factory AppColors.light() {
    const primary = BrandPalette.primary;
    const white = BrandPalette.white;
    return AppColors(
      primary: primary,
      onPrimary: white,
      primaryStrong: BrandPalette.primaryDeep,
      primarySoft: BrandPalette.primarySoft,
      primarySurface: BrandPalette.primaryWash,
      primaryBorder: _mix(primary, white, _borderMix),
      background: BrandPalette.canvas,
      surface: white,
      surfaceMuted: _mix(primary, BrandPalette.line, _mutedMix),
      textPrimary: BrandPalette.ink,
      textSecondary: BrandPalette.inkMuted,
      textTertiary: BrandPalette.inkSubtle,
      border: BrandPalette.line,
      success: BrandPalette.success,
      successSoft: BrandPalette.successSoft,
      warning: BrandPalette.warning,
      warningSoft: _mix(BrandPalette.warning, white, _softMix),
      danger: BrandPalette.danger,
      dangerSoft: _mix(BrandPalette.danger, white, _softMix),
      gold: BrandPalette.gold,
      goldSoft: BrandPalette.goldSoft,
      goldBorder: _mix(BrandPalette.gold, white, _borderMix),
      shimmerBase: _mix(primary, BrandPalette.line, _shimmerBaseMix),
      shimmerHighlight: _mix(primary, white, _shimmerHighlightMix),
      scrim: BrandPalette.ink.withValues(alpha: _scrimAlpha),
      inverseSurface: BrandPalette.ink,
      onInverseSurface: white,
      borderStrong: BrandPalette.lineStrong,
      goldDeep: BrandPalette.goldDeep,
      heroStart: BrandPalette.primaryGradientStart,
      heroEnd: BrandPalette.primaryGradientEnd,
    );
  }

  factory AppColors.dark() {
    final primary = _mix(
      BrandPalette.primary,
      BrandPalette.white,
      _darkPrimaryLift,
    );
    const surface = BrandPalette.darkSurface;
    return AppColors(
      primary: primary,
      onPrimary: BrandPalette.white,
      primaryStrong: BrandPalette.primary,
      primarySoft: _mix(primary, surface, _darkSoftMix),
      primarySurface: _mix(primary, surface, _darkSurfaceMix),
      primaryBorder: _mix(primary, surface, _borderMix),
      background: BrandPalette.darkCanvas,
      surface: surface,
      surfaceMuted: BrandPalette.darkLine,
      textPrimary: BrandPalette.darkInk,
      textSecondary: BrandPalette.darkInkMuted,
      textTertiary: _mix(BrandPalette.darkInkMuted, surface, _tertiaryMix),
      border: BrandPalette.darkLine,
      success: BrandPalette.success,
      successSoft: _mix(BrandPalette.success, surface, _darkSoftMix),
      warning: BrandPalette.warning,
      warningSoft: _mix(BrandPalette.warning, surface, _darkSoftMix),
      danger: BrandPalette.danger,
      dangerSoft: _mix(BrandPalette.danger, surface, _darkSoftMix),
      gold: BrandPalette.darkInkMuted,
      goldSoft: _mix(BrandPalette.darkInkMuted, surface, _darkSoftMix),
      goldBorder: _mix(BrandPalette.darkInkMuted, surface, _borderMix),
      shimmerBase: BrandPalette.darkLine,
      shimmerHighlight: _mix(
        BrandPalette.darkLine,
        BrandPalette.white,
        _darkShimmerMix,
      ),
      scrim: BrandPalette.black.withValues(alpha: _scrimAlpha),
      inverseSurface: BrandPalette.darkInk,
      onInverseSurface: BrandPalette.ink,
      borderStrong: _mix(BrandPalette.darkLine, BrandPalette.white, _darkShimmerMix),
      goldDeep: BrandPalette.darkInkMuted,
      heroStart: BrandPalette.primaryGradientStart,
      heroEnd: BrandPalette.primaryGradientEnd,
    );
  }

  static const double _borderMix = 0.45;
  static const double _mutedMix = 0.92;
  static const double _softMix = 0.88;
  static const double _tertiaryMix = 0.35;
  static const double _shimmerBaseMix = 0.94;
  static const double _shimmerHighlightMix = 0.98;
  static const double _scrimAlpha = 0.45;
  static const double _darkPrimaryLift = 0.12;
  static const double _darkSoftMix = 0.8;
  static const double _darkSurfaceMix = 0.88;
  static const double _darkShimmerMix = 0.08;

  final Color primary;
  final Color onPrimary;
  final Color primaryStrong;
  final Color primarySoft;
  final Color primarySurface;
  final Color primaryBorder;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color gold;
  final Color goldSoft;
  final Color goldBorder;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color borderStrong;
  final Color goldDeep;
  final Color heroStart;
  final Color heroEnd;

  LinearGradient get heroGradient => LinearGradient(colors: [heroStart, heroEnd]);

  static Color _mix(Color from, Color to, double amount) => Color.lerp(from, to, amount)!;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryStrong,
    Color? primarySoft,
    Color? primarySurface,
    Color? primaryBorder,
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? gold,
    Color? goldSoft,
    Color? goldBorder,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? borderStrong,
    Color? goldDeep,
    Color? heroStart,
    Color? heroEnd,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      primarySoft: primarySoft ?? this.primarySoft,
      primarySurface: primarySurface ?? this.primarySurface,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      gold: gold ?? this.gold,
      goldSoft: goldSoft ?? this.goldSoft,
      goldBorder: goldBorder ?? this.goldBorder,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      scrim: scrim ?? this.scrim,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      borderStrong: borderStrong ?? this.borderStrong,
      goldDeep: goldDeep ?? this.goldDeep,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppColors(
      primary: _mix(primary, other.primary, t),
      onPrimary: _mix(onPrimary, other.onPrimary, t),
      primaryStrong: _mix(primaryStrong, other.primaryStrong, t),
      primarySoft: _mix(primarySoft, other.primarySoft, t),
      primarySurface: _mix(primarySurface, other.primarySurface, t),
      primaryBorder: _mix(primaryBorder, other.primaryBorder, t),
      background: _mix(background, other.background, t),
      surface: _mix(surface, other.surface, t),
      surfaceMuted: _mix(surfaceMuted, other.surfaceMuted, t),
      textPrimary: _mix(textPrimary, other.textPrimary, t),
      textSecondary: _mix(textSecondary, other.textSecondary, t),
      textTertiary: _mix(textTertiary, other.textTertiary, t),
      border: _mix(border, other.border, t),
      success: _mix(success, other.success, t),
      successSoft: _mix(successSoft, other.successSoft, t),
      warning: _mix(warning, other.warning, t),
      warningSoft: _mix(warningSoft, other.warningSoft, t),
      danger: _mix(danger, other.danger, t),
      dangerSoft: _mix(dangerSoft, other.dangerSoft, t),
      gold: _mix(gold, other.gold, t),
      goldSoft: _mix(goldSoft, other.goldSoft, t),
      goldBorder: _mix(goldBorder, other.goldBorder, t),
      shimmerBase: _mix(shimmerBase, other.shimmerBase, t),
      shimmerHighlight: _mix(shimmerHighlight, other.shimmerHighlight, t),
      scrim: _mix(scrim, other.scrim, t),
      inverseSurface: _mix(inverseSurface, other.inverseSurface, t),
      onInverseSurface: _mix(onInverseSurface, other.onInverseSurface, t),
      borderStrong: _mix(borderStrong, other.borderStrong, t),
      goldDeep: _mix(goldDeep, other.goldDeep, t),
      heroStart: _mix(heroStart, other.heroStart, t),
      heroEnd: _mix(heroEnd, other.heroEnd, t),
    );
  }
}
