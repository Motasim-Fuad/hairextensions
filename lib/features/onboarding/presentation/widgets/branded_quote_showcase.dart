import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/onboarding/presentation/constants/onboarding_sample.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_card.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/showcase_value_row.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/media/monogram_avatar.dart';

class BrandedQuoteShowcase extends StatelessWidget {
  const BrandedQuoteShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    String money(int minor) => MoneyFormatter.format(minor, OnboardingSample.currency, showDecimals: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.cardGap,
      children: [
        ShowcaseCard(
          gap: AppSpacing.chipX,
          children: [
            Row(
              spacing: AppSpacing.md,
              children: [
                MonogramAvatar(name: l10n.sampleBusinessName, size: AppSizes.avatar),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.sampleBusinessName,
                        style: AppTextStyles.detailStrong.copyWith(color: colors.textPrimary),
                      ),
                      Text(
                        l10n.sampleBusinessContact,
                        style: AppTextStyles.micro.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.accentRule,
              child: ColoredBox(color: colors.primary),
            ),
            Text(l10n.documentQuotation, style: AppTextStyles.documentTitle.copyWith(color: colors.textPrimary)),
            ShowcaseValueRow(label: l10n.sampleServiceName, value: money(OnboardingSample.totalMinor)),
            ShowcaseValueRow(label: l10n.labelDeposit, value: money(OnboardingSample.depositMinor)),
            ShowcaseValueRow(
              label: l10n.labelBalanceDue,
              value: money(OnboardingSample.balanceMinor),
              valueColor: colors.primary,
            ),
            SizedBox(
              height: AppSizes.compactActionHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.smAll),
                child: Center(
                  child: Text(
                    l10n.actionPayDeposit,
                    style: AppTextStyles.detailStrong.copyWith(color: colors.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            for (final icon in const [AppIcon.share, AppIcon.mail, AppIcon.link])
              IconBadge(icon: icon, size: AppSizes.avatar, background: colors.surface),
          ],
        ),
      ],
    );
  }
}
