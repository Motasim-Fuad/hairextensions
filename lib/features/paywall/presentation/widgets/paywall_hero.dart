import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';

class PaywallHero extends StatelessWidget {
  const PaywallHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      spacing: AppSpacing.md,
      children: [
        IconBadge(
          icon: AppIcon.crown,
          size: AppSizes.iconBadgeHero,
          background: colors.goldSoft,
          foreground: colors.gold,
        ),
        Text(
          l10n.paywallTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle.copyWith(color: colors.textPrimary),
        ),
        Text(
          l10n.paywallSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.lead.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
