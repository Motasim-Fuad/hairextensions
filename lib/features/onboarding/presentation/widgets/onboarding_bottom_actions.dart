import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_page_dots.dart';

class OnboardingBottomActions extends StatelessWidget {
  const OnboardingBottomActions({required this.onNext, required this.onFinish, super.key});

  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.lg),
      child: BlocBuilder<OnboardingCubit, int>(
        builder: (context, page) {
          final isLast = page == OnboardingCubit.pageCount - 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              AppPageDots(count: OnboardingCubit.pageCount, index: page),
              AppPrimaryButton(
                label: isLast ? l10n.actionGetStarted : l10n.actionNext,
                trailingIcon: AppIcon.chevronRight,
                onPressed: isLast ? onFinish : onNext,
              ),
            ],
          );
        },
      ),
    );
  }
}
