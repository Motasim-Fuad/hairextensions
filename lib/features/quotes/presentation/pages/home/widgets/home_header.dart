import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/media/business_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.businessName,
    required this.greetingName,
    required this.hour,
    required this.onSearch,
    super.key,
    this.logoPath,
  });

  static const int _afternoonStart = 12;
  static const int _eveningStart = 17;

  final String businessName;
  final String greetingName;
  final String? logoPath;
  final int hour;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final greeting = hour < _afternoonStart
        ? l10n.greetingMorning
        : hour < _eveningStart
        ? l10n.greetingAfternoon
        : l10n.greetingEvening;
    return Row(
      spacing: AppSpacing.md,
      children: [
        BusinessLogo(businessName: businessName, logoPath: logoPath, size: AppSizes.iconBadgeLarge),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: AppTextStyles.greeting.copyWith(color: colors.textSecondary)),
              Text(
                greetingName,
                style: AppTextStyles.displayName.copyWith(color: colors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: AppIcon.search,
          semanticLabel: l10n.actionSearch,
          dimension: AppSizes.iconBadgeLarge,
          onPressed: onSearch,
        ),
      ],
    );
  }
}
