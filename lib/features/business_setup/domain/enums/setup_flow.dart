import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';

/// The wizard runs on first launch; Settings reuses the same forms to edit.
enum SetupFlow {
  onboarding([SetupStep.identity, SetupStep.contact, SetupStep.quoteDefaults]),
  editProfile([SetupStep.identity, SetupStep.contact]),
  editQuoteDefaults([SetupStep.quoteDefaults]);

  const SetupFlow(this.steps);

  final List<SetupStep> steps;

  bool get isOnboarding => this == onboarding;
}
