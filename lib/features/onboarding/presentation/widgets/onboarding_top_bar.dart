import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/shared/widgets/feedback/app_pill_label.dart';

/// Step counter and Skip. Skip is hidden on the last page, as in the design.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({required this.onSkip, super.key});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.sm, 0),
      child: SizedBox(
        height: AppSizes.minTapTarget,
        child: BlocBuilder<OnboardingCubit, int>(
          builder: (context, page) {
            final isLast = page == OnboardingCubit.pageCount - 1;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppPillLabel(label: l10n.onboardingStep(page + 1, OnboardingCubit.pageCount)),
                if (!isLast)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      textStyle: AppTextStyles.action,
                    ),
                    child: Text(l10n.actionSkip),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
