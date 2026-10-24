import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_progress_bar.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, ({int index, int total, SetupFlow flow})>(
      selector: (state) => (index: state.stepIndex, total: state.stepCount, flow: state.flow),
      builder: (context, header) {
        final l10n = context.l10n;
        final canGoBack = header.index > 0 || Navigator.of(context).canPop();
        final title = switch (header.flow) {
          SetupFlow.onboarding => l10n.setupStepLabel(header.index + 1, header.total),
          SetupFlow.editProfile => l10n.setupEditProfileTitle,
          SetupFlow.editQuoteDefaults => l10n.setupQuoteDefaultsTitle,
        };
        return Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.xs, AppSpacing.sm, AppSpacing.sm),
          child: Column(
            children: [
              SizedBox(
                height: AppSizes.minTapTarget,
                child: Row(
                  children: [
                    if (canGoBack)
                      AppIconButton(
                        icon: AppIcon.chevronLeft,
                        semanticLabel: l10n.actionBack,
                        onPressed: () => Navigator.of(context).maybePop(),
                      )
                    else
                      const SizedBox(width: AppSizes.minTapTarget),
                    Expanded(
                      child: Text(title, textAlign: TextAlign.center, style: context.textTheme.titleSmall),
                    ),
                    const SizedBox(width: AppSizes.minTapTarget),
                  ],
                ),
              ),
              if (header.total > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: SetupProgressBar(current: header.index, total: header.total),
                ),
            ],
          ),
        );
      },
    );
  }
}
