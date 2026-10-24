import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_status.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/layout/bottom_action_bar.dart';

/// Save failures appear as text under the button with a retry, never as a
/// snackbar.
class SetupContinueBar extends StatelessWidget {
  const SetupContinueBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      BusinessSetupBloc,
      BusinessSetupState,
      ({bool isVisible, bool isSaving, bool isLastStep, SetupFlow flow, Failure? failure})
    >(
      selector: (state) => (
        isVisible: state.status != BusinessSetupStatus.loading && state.status != BusinessSetupStatus.loadFailure,
        isSaving: state.isSaving || state.status.isDone,
        isLastStep: state.isLastStep,
        flow: state.flow,
        failure: state.saveFailure,
      ),
      builder: (context, bar) {
        if (!bar.isVisible) {
          return const SizedBox.shrink();
        }
        final l10n = context.l10n;
        final label = !bar.isLastStep
            ? l10n.actionContinue
            : bar.flow.isOnboarding
            ? l10n.actionFinishSetup
            : l10n.actionSave;
        void submit() => context.read<BusinessSetupBloc>().add(const BusinessSetupContinuePressed());
        return BottomActionBar(
          child: AppPrimaryButton(
            label: label,
            trailingIcon: bar.isLastStep ? AppIcon.check : AppIcon.chevronRight,
            isLoading: bar.isSaving,
            onPressed: submit,
            errorText: bar.failure?.localizedMessage(l10n),
            onRetry: bar.failure == null ? null : submit,
            retryLabel: l10n.actionRetry,
          ),
        );
      },
    );
  }
}
