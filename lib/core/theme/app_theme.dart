import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_colors.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/theme/tokens/app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light(), Brightness.light);

  static ThemeData dark() => _build(AppColors.dark(), Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final text = AppTypography.textTheme(colors);
    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primarySoft,
      onPrimaryContainer: colors.primary,
      secondary: colors.gold,
      onSecondary: colors.onPrimary,
      error: colors.danger,
      onError: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      surfaceContainerHighest: colors.surfaceMuted,
      outline: colors.border,
      outlineVariant: colors.border,
      inverseSurface: colors.inverseSurface,
      onInverseSurface: colors.onInverseSurface,
      scrim: colors.scrim,
      surfaceTint: Colors.transparent,
    );
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.buttonAll);
    OutlineInputBorder outline(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: [colors],
      textTheme: text,
      fontFamily: AppTypography.bodyFamily,
      fontFamilyFallback: AppTypography.bodyFallback,
      scaffoldBackgroundColor: colors.background,
      splashFactory: InkRipple.splashFactory,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: text.headlineMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: colors.textTertiary),
        labelStyle: text.bodySmall,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: outline(colors.border, AppSizes.borderThin),
        enabledBorder: outline(colors.border, AppSizes.borderThin),
        focusedBorder: outline(colors.primary, AppSizes.borderFocus),
        errorBorder: outline(colors.danger, AppSizes.borderThin),
        focusedErrorBorder: outline(colors.danger, AppSizes.borderFocus),
        errorStyle: text.bodySmall?.copyWith(color: colors.danger),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primaryBorder,
          disabledForegroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: buttonShape,
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: buttonShape,
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryStrong,
          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          textStyle: text.labelMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.textPrimary,
          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? colors.primary : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(colors.onPrimary),
        side: BorderSide(color: colors.borderStrong, width: AppSizes.borderFocus),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xsAll),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(colors.surface),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? colors.primary : colors.surfaceMuted,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: AppSizes.borderThin,
        space: AppSizes.borderThin,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: colors.scrim,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        showDragHandle: true,
        dragHandleColor: colors.border,
        dragHandleSize: const Size(
          AppSizes.sheetHandleWidth,
          AppSizes.sheetHandleHeight,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: colors.scrim,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: text.headlineSmall,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: colors.textSecondary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionHandleColor: colors.primary,
        selectionColor: colors.primarySoft,
      ),
    );
  }
}
