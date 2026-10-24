import 'package:flutter/services.dart';
import 'package:hairextensions/core/theme/tokens/app_typography.dart';

/// Loads the real fonts so golden images show text instead of boxes.
Future<void> loadAppFonts() async {
  const fonts = {
    AppTypography.displayFamily: 'assets/fonts/PlayfairDisplay.ttf',
    // Helvetica is a system font that is absent in tests, so both the primary
    // family and its bundled fallback resolve to Arimo.
    AppTypography.bodyFamily: 'assets/fonts/Arimo.ttf',
    AppTypography.bodyFallbackFamily: 'assets/fonts/Arimo.ttf',
    'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
  };
  for (final entry in fonts.entries) {
    final loader = FontLoader(entry.key)..addFont(rootBundle.load(entry.value));
    await loader.load();
  }
}
