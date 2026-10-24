import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/permissions/permission_service.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';
import 'package:hairextensions/features/business_setup/domain/usecases/get_business_profile.dart';
import 'package:hairextensions/features/business_setup/domain/usecases/pick_business_logo.dart';
import 'package:hairextensions/features/business_setup/domain/usecases/save_business_profile.dart';
import 'package:hairextensions/features/business_setup/domain/validators/business_profile_validator.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_status.dart';
import 'package:injectable/injectable.dart';

part 'business_setup_event.dart';
part 'business_setup_state.dart';
part 'events/business_setup_back_pressed.dart';
part 'events/business_setup_continue_pressed.dart';
part 'events/business_setup_currency_changed.dart';
part 'events/business_setup_deposit_type_changed.dart';
part 'events/business_setup_field_changed.dart';
part 'events/business_setup_logo_pick_requested.dart';
part 'events/business_setup_logo_removed.dart';
part 'events/business_setup_settings_requested.dart';
part 'events/business_setup_started.dart';

/// Drives the first-launch wizard and the Settings edit screens. Every
/// Continue saves locally, so a killed app resumes with the typed values.
@injectable
class BusinessSetupBloc extends Bloc<BusinessSetupEvent, BusinessSetupState> {
  BusinessSetupBloc(this._getProfile, this._saveProfile, this._pickLogo, this._permissions)
    : super(BusinessSetupState.initial()) {
    on<BusinessSetupStarted>(_onStarted);
    on<BusinessSetupFieldChanged>(_onFieldChanged);
    on<BusinessSetupCurrencyChanged>(_onCurrencyChanged);
    on<BusinessSetupDepositTypeChanged>(_onDepositTypeChanged);
    on<BusinessSetupLogoPickRequested>(_onLogoPickRequested);
    on<BusinessSetupLogoRemoved>(_onLogoRemoved);
    on<BusinessSetupContinuePressed>(_onContinuePressed);
    on<BusinessSetupBackPressed>(_onBackPressed);
    on<BusinessSetupSettingsRequested>(_onSettingsRequested);
  }

  final GetBusinessProfile _getProfile;
  final SaveBusinessProfile _saveProfile;
  final PickBusinessLogo _pickLogo;
  final PermissionService _permissions;

  Future<void> _onStarted(BusinessSetupStarted event, Emitter<BusinessSetupState> emit) async {
    emit(
      state.copyWith(
        flow: event.flow,
        status: BusinessSetupStatus.loading,
        stepIndex: 0,
        loadFailure: () => null,
      ),
    );
    final result = await _getProfile();
    result.match(
      (failure) => emit(state.copyWith(status: BusinessSetupStatus.loadFailure, loadFailure: () => failure)),
      (profile) => emit(
        state.copyWith(
          status: BusinessSetupStatus.editing,
          draft: BusinessProfileDraft.fromProfile(profile),
          base: () => profile,
        ),
      ),
    );
  }

  void _onFieldChanged(BusinessSetupFieldChanged event, Emitter<BusinessSetupState> emit) {
    _emitDraft(emit, state.draft.withValue(event.field, event.value));
  }

  void _onCurrencyChanged(BusinessSetupCurrencyChanged event, Emitter<BusinessSetupState> emit) {
    _emitDraft(emit, state.draft.withCurrency(event.currencyCode));
  }

  void _onDepositTypeChanged(BusinessSetupDepositTypeChanged event, Emitter<BusinessSetupState> emit) {
    _emitDraft(emit, state.draft.withDepositType(event.depositType));
  }

  Future<void> _onLogoPickRequested(BusinessSetupLogoPickRequested event, Emitter<BusinessSetupState> emit) async {
    if (state.isPickingLogo) {
      return;
    }
    emit(state.copyWith(isPickingLogo: true, logoFailure: () => null));
    final result = await _pickLogo();
    result.match(
      (failure) => emit(state.copyWith(isPickingLogo: false, logoFailure: () => failure)),
      (path) => emit(
        state.copyWith(isPickingLogo: false, draft: path == null ? null : state.draft.withLogo(path)),
      ),
    );
  }

  void _onLogoRemoved(BusinessSetupLogoRemoved event, Emitter<BusinessSetupState> emit) {
    emit(state.copyWith(draft: state.draft.withLogo(null), logoFailure: () => null));
  }

  Future<void> _onContinuePressed(BusinessSetupContinuePressed event, Emitter<BusinessSetupState> emit) async {
    if (state.status != BusinessSetupStatus.editing) {
      return;
    }
    final errors = BusinessProfileValidator.validate(state.currentStep, state.draft);
    if (errors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: errors, showErrors: true, saveFailure: () => null));
      return;
    }
    emit(state.copyWith(status: BusinessSetupStatus.saving, fieldErrors: const {}, saveFailure: () => null));
    final profile = state.draft.toProfile(base: state.base);
    final finishing = state.isLastStep;
    final result = await _saveProfile(profile, completeSetup: finishing && state.flow.isOnboarding);
    result.match(
      (failure) => emit(state.copyWith(status: BusinessSetupStatus.editing, saveFailure: () => failure)),
      (_) {
        if (finishing) {
          emit(
            state.copyWith(
              status: state.flow.isOnboarding ? BusinessSetupStatus.completed : BusinessSetupStatus.saved,
              base: () => profile,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: BusinessSetupStatus.editing,
            stepIndex: state.stepIndex + 1,
            base: () => profile,
            showErrors: false,
          ),
        );
      },
    );
  }

  void _onBackPressed(BusinessSetupBackPressed event, Emitter<BusinessSetupState> emit) {
    if (state.stepIndex == 0 || state.isSaving) {
      return;
    }
    emit(
      state.copyWith(
        stepIndex: state.stepIndex - 1,
        showErrors: false,
        fieldErrors: const {},
        saveFailure: () => null,
      ),
    );
  }

  Future<void> _onSettingsRequested(BusinessSetupSettingsRequested event, Emitter<BusinessSetupState> emit) async {
    await _permissions.openSettings();
    emit(state.copyWith(logoFailure: () => null));
  }

  void _emitDraft(Emitter<BusinessSetupState> emit, BusinessProfileDraft draft) {
    emit(
      state.copyWith(
        draft: draft,
        fieldErrors: state.showErrors ? BusinessProfileValidator.validate(state.currentStep, draft) : null,
        saveFailure: () => null,
      ),
    );
  }
}
