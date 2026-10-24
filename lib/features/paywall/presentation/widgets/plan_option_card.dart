import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/inputs/app_radio_mark.dart';

class PlanOptionCard extends StatelessWidget {
  const PlanOptionCard({
    required this.title,
    required this.detail,
    required this.price,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.badge,
  });

  final String title;
  final String detail;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final badgeLabel = badge;
    return Semantics(
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: context.motion(AppMotion.fast),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isSelected ? colors.primarySurface : colors.surface,
            borderRadius: AppRadius.lgAll,
            border: Border.all(
              color: isSelected ? colors.primary : colors.borderStrong,
              width: isSelected ? AppSizes.planBorderSelected : AppSizes.borderThin,
            ),
          ),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              AppRadioMark(isSelected: isSelected),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Row(
                      spacing: AppSpacing.sm,
                      children: [
                        Text(title, style: AppTextStyles.planTitle.copyWith(color: colors.textPrimary)),
                        if (badgeLabel != null)
                          DecoratedBox(
                            decoration: BoxDecoration(color: colors.gold, borderRadius: AppRadius.pillAll),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.chipX,
                                vertical: AppSpacing.xs,
                              ),
                              child: Text(badgeLabel, style: AppTextStyles.chip.copyWith(color: colors.onPrimary)),
                            ),
                          ),
                      ],
                    ),
                    Text(detail, style: AppTextStyles.caption.copyWith(color: colors.textSecondary)),
                  ],
                ),
              ),
              Text(
                price,
                style: AppTextStyles.planTitle.copyWith(color: isSelected ? colors.primary : colors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
