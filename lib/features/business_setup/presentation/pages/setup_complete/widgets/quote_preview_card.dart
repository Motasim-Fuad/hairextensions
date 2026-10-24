import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/shared/widgets/layout/labeled_value_row.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';
import 'package:hairextensions/shared/widgets/media/business_logo.dart';

/// A miniature of the quote header clients will see, built from the saved
/// profile. Empty optional fields are left out rather than shown blank.
class QuotePreviewCard extends StatelessWidget {
  const QuotePreviewCard({required this.profile, super.key});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final tagline = profile.tagline;
    final deposit = profile.depositType == DepositType.percent
        ? l10n.percentValue(PercentFormatter.format(profile.depositPercent))
        : MoneyFormatter.format(profile.depositFixedMinor, profile.currencyCode);
    final rows = <(String, String?)>[
      (l10n.fieldPhone, profile.phone),
      (l10n.fieldEmail, profile.email),
      (l10n.fieldInstagram, profile.instagram),
      (l10n.previewVat, l10n.percentValue(PercentFormatter.format(profile.taxRatePercent))),
      (l10n.fieldDefaultDeposit, deposit),
    ];
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BusinessLogo(businessName: profile.businessName, logoPath: profile.logoPath),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.businessName,
                      style: context.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tagline != null)
                      Text(
                        tagline,
                        style: context.textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Text(l10n.previewDocumentLabel, style: context.textTheme.titleSmall?.copyWith(color: colors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: AppSizes.dividerThick, thickness: AppSizes.dividerThick, color: colors.primary),
          const SizedBox(height: AppSpacing.sm),
          for (final (label, value) in rows)
            if (value != null && value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: LabeledValueRow(label: label, value: value),
              ),
        ],
      ),
    );
  }
}
