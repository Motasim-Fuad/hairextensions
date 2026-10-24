import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/contact_step_form.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/identity_step_form.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/quote_defaults_step_form.dart';
import 'package:hairextensions/shared/widgets/animations/fade_slide_switcher.dart';
import 'package:hairextensions/shared/widgets/responsive/max_width_box.dart';

class SetupStepBody extends StatelessWidget {
  const SetupStepBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, SetupStep>(
      selector: (state) => state.currentStep,
      builder: (context, step) {
        return FadeSlideSwitcher(
          child: SingleChildScrollView(
            key: ValueKey(step),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: MaxWidthBox(
              child: switch (step) {
                SetupStep.identity => const IdentityStepForm(),
                SetupStep.contact => const ContactStepForm(),
                SetupStep.quoteDefaults => const QuoteDefaultsStepForm(),
              },
            ),
          ),
        );
      },
    );
  }
}
