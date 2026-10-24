import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';

/// Gradient brand screen: logo mark, app name and tagline.
class BrandSplash extends StatelessWidget {
  const BrandSplash({super.key});

  static const double _taglineAlpha = 0.8;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: colors.heroGradient),
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: AppSizes.splashLogo,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: AppRadius.xxlAll,
                      boxShadow: AppShadows.logo,
                    ),
                    child: Center(
                      child: Text(
                        l10n.appName.characters.first,
                        style: AppTextStyles.logoMark.copyWith(color: colors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.appName, style: AppTextStyles.splashTitle.copyWith(color: colors.onPrimary)),
                const SizedBox(height: AppSpacing.dotGap),
                Text(
                  l10n.appTagline,
                  style: AppTextStyles.feature.copyWith(color: colors.onPrimary.withValues(alpha: _taglineAlpha)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
