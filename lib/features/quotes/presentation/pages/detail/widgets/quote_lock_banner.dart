import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class QuoteLockBanner extends StatelessWidget {
  const QuoteLockBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.goldSoft, borderRadius: AppRadius.mdAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            AppSvgIcon(AppIcon.lock, size: AppSizes.iconSm, color: colors.goldDeep),
            Expanded(
              child: Text(
                context.l10n.quoteLockedNotice,
                style: AppTextStyles.caption.copyWith(color: colors.goldDeep),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
