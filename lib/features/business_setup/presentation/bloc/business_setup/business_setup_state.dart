part of 'business_setup_bloc.dart';

final class BusinessSetupState extends Equatable {
  const BusinessSetupState({
    required this.flow,
    required this.status,
    required this.stepIndex,
    required this.draft,
    this.base,
    this.fieldErrors = const {},
    this.showErrors = false,
    this.isPickingLogo = false,
    this.loadFailure,
    this.saveFailure,
    this.logoFailure,
  });

  factory BusinessSetupState.initial() {
    return BusinessSetupState(
      flow: SetupFlow.onboarding,
      status: BusinessSetupStatus.loading,
      stepIndex: 0,
      draft: BusinessProfileDraft.fromProfile(null),
    );
  }

  final SetupFlow flow;
  final BusinessSetupStatus status;
  final int stepIndex;
  final BusinessProfileDraft draft;

  /// The saved profile; fields this flow does not edit are kept from it.
  final BusinessProfile? base;
  final Map<SetupField, SetupFieldError> fieldErrors;

  /// Errors appear only after the first Continue on a step, then update live.
  final bool showErrors;
  final bool isPickingLogo;
  final Failure? loadFailure;
  final Failure? saveFailure;
  final Failure? logoFailure;

  List<SetupStep> get steps => flow.steps;

  SetupStep get currentStep => steps[stepIndex];

  int get stepCount => steps.length;

  bool get isLastStep => stepIndex == stepCount - 1;

  bool get isSaving => status == BusinessSetupStatus.saving;

  SetupFieldError? errorFor(SetupField field) => showErrors ? fieldErrors[field] : null;

  BusinessSetupState copyWith({
    SetupFlow? flow,
    BusinessSetupStatus? status,
    int? stepIndex,
    BusinessProfileDraft? draft,
    BusinessProfile? Function()? base,
    Map<SetupField, SetupFieldError>? fieldErrors,
    bool? showErrors,
    bool? isPickingLogo,
    Failure? Function()? loadFailure,
    Failure? Function()? saveFailure,
    Failure? Function()? logoFailure,
  }) {
    return BusinessSetupState(
      flow: flow ?? this.flow,
      status: status ?? this.status,
      stepIndex: stepIndex ?? this.stepIndex,
      draft: draft ?? this.draft,
      base: base == null ? this.base : base(),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      showErrors: showErrors ?? this.showErrors,
      isPickingLogo: isPickingLogo ?? this.isPickingLogo,
      loadFailure: loadFailure == null ? this.loadFailure : loadFailure(),
      saveFailure: saveFailure == null ? this.saveFailure : saveFailure(),
      logoFailure: logoFailure == null ? this.logoFailure : logoFailure(),
    );
  }

  @override
  List<Object?> get props => [
    flow,
    status,
    stepIndex,
    draft,
    base,
    fieldErrors,
    showErrors,
    isPickingLogo,
    loadFailure,
    saveFailure,
    logoFailure,
  ];
}
