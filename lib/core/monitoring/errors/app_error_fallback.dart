import 'package:flutter/material.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_colors.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Release-mode replacement for ErrorWidget. It can be built above
/// MaterialApp, so theme, localizations and directionality are all optional.
class AppErrorFallback extends StatelessWidget {
  const AppErrorFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light();
    final l10n =
        Localizations.of<AppLocalizations>(context, AppLocalizations) ?? lookupAppLocalizations(AppLocales.fallback);
    final content = DecoratedBox(
      decoration: BoxDecoration(color: colors.dangerSoft, borderRadius: AppRadius.mdAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(AppIcon.alert, size: AppSizes.iconSm, color: colors.danger),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                l10n.errorFallbackMessage,
                style: TextStyle(color: colors.danger),
              ),
            ),
          ],
        ),
      ),
    );
    if (Directionality.maybeOf(context) != null) {
      return content;
    }
    return Directionality(textDirection: TextDirection.ltr, child: content);
  }
}
