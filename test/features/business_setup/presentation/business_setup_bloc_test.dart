import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_status.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/business_profile_fixture.dart';
import '../../../helpers/mocks/mock_get_business_profile.dart';
import '../../../helpers/mocks/mock_permission_service.dart';
import '../../../helpers/mocks/mock_pick_business_logo.dart';
import '../../../helpers/mocks/mock_save_business_profile.dart';

void main() {
  late MockGetBusinessProfile getProfile;
  late MockSaveBusinessProfile saveProfile;
  late MockPickBusinessLogo pickLogo;
  late MockPermissionService permissions;

  setUpAll(() => registerFallbackValue(BusinessProfileFixture.glamStrands));

  setUp(() {
    getProfile = MockGetBusinessProfile();
    saveProfile = MockSaveBusinessProfile();
    pickLogo = MockPickBusinessLogo();
    permissions = MockPermissionService();
    when(() => getProfile()).thenAnswer((_) async => const Right(null));
    when(
      () => saveProfile(any(), completeSetup: any(named: 'completeSetup')),
    ).thenAnswer((_) async => const Right(unit));
  });

  BusinessSetupBloc build() => BusinessSetupBloc(getProfile, saveProfile, pickLogo, permissions);

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'loads an existing profile into the draft',
    setUp: () => when(() => getProfile()).thenAnswer((_) async => const Right(BusinessProfileFixture.glamStrands)),
    build: build,
    act: (bloc) => bloc.add(const BusinessSetupStarted(SetupFlow.onboarding)),
    verify: (bloc) {
      expect(bloc.state.status, BusinessSetupStatus.editing);
      expect(bloc.state.draft.valueOf(SetupField.businessName), 'Glam Strands Studio');
      expect(bloc.state.base, BusinessProfileFixture.glamStrands);
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'a load failure is exposed for the inline retry',
    setUp: () => when(() => getProfile()).thenAnswer((_) async => const Left(LocalStorageFailure())),
    build: build,
    act: (bloc) => bloc.add(const BusinessSetupStarted(SetupFlow.onboarding)),
    verify: (bloc) {
      expect(bloc.state.status, BusinessSetupStatus.loadFailure);
      expect(bloc.state.loadFailure, isA<LocalStorageFailure>());
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'continue with an empty name shows the error and does not save',
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc.add(const BusinessSetupContinuePressed());
    },
    verify: (bloc) {
      expect(bloc.state.errorFor(SetupField.businessName), SetupFieldError.required);
      expect(bloc.state.stepIndex, 0);
      verifyNever(() => saveProfile(any(), completeSetup: any(named: 'completeSetup')));
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'errors clear live once the user fixes the field',
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc
        ..add(const BusinessSetupContinuePressed())
        ..add(const BusinessSetupFieldChanged(SetupField.businessName, 'Glam'));
    },
    verify: (bloc) => expect(bloc.state.errorFor(SetupField.businessName), isNull),
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'walks all three steps, saving each, and completes setup on the last',
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc.add(const BusinessSetupFieldChanged(SetupField.businessName, 'Glam Strands Studio'));
      for (var step = 0; step < 3; step++) {
        bloc.add(const BusinessSetupContinuePressed());
        await pumpEventQueue();
      }
    },
    verify: (bloc) {
      expect(bloc.state.status, BusinessSetupStatus.completed);
      verify(() => saveProfile(any(), completeSetup: false)).called(2);
      final saved = verify(() => saveProfile(captureAny(), completeSetup: true)).captured.single as BusinessProfile;
      expect(saved.businessName, 'Glam Strands Studio');
      expect(saved.taxRatePercent, 5);
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'a save failure keeps the user on the step with the failure shown',
    setUp: () => when(
      () => saveProfile(any(), completeSetup: any(named: 'completeSetup')),
    ).thenAnswer((_) async => const Left(LocalStorageFailure())),
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc
        ..add(const BusinessSetupFieldChanged(SetupField.businessName, 'Glam'))
        ..add(const BusinessSetupContinuePressed());
    },
    verify: (bloc) {
      expect(bloc.state.status, BusinessSetupStatus.editing);
      expect(bloc.state.stepIndex, 0);
      expect(bloc.state.saveFailure, isA<LocalStorageFailure>());
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'back returns to the previous step',
    setUp: () => when(() => getProfile()).thenAnswer((_) async => const Right(BusinessProfileFixture.glamStrands)),
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc.add(const BusinessSetupContinuePressed());
      await pumpEventQueue();
      bloc.add(const BusinessSetupBackPressed());
    },
    verify: (bloc) => expect(bloc.state.currentStep, SetupStep.identity),
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'the quote defaults edit flow saves without touching the setup flag',
    setUp: () => when(() => getProfile()).thenAnswer((_) async => const Right(BusinessProfileFixture.glamStrands)),
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.editQuoteDefaults));
      await pumpEventQueue();
      bloc
        ..add(const BusinessSetupFieldChanged(SetupField.taxRate, '7.5'))
        ..add(const BusinessSetupContinuePressed());
    },
    verify: (bloc) {
      expect(bloc.state.status, BusinessSetupStatus.saved);
      final saved = verify(() => saveProfile(captureAny(), completeSetup: false)).captured.single as BusinessProfile;
      expect(saved.taxRatePercent, 7.5);
      expect(saved.nextQuoteNumber, BusinessProfileFixture.glamStrands.nextQuoteNumber);
    },
  );

  blocTest<BusinessSetupBloc, BusinessSetupState>(
    'a picked logo lands in the draft; cancelling changes nothing',
    setUp: () => when(() => pickLogo()).thenAnswer((_) async => const Right('/logos/logo_1.png')),
    build: build,
    act: (bloc) async {
      bloc.add(const BusinessSetupStarted(SetupFlow.onboarding));
      await pumpEventQueue();
      bloc.add(const BusinessSetupLogoPickRequested());
      await pumpEventQueue();
      when(() => pickLogo()).thenAnswer((_) async => const Right(null));
      bloc.add(const BusinessSetupLogoPickRequested());
    },
    verify: (bloc) {
      expect(bloc.state.draft.logoPath, '/logos/logo_1.png');
      expect(bloc.state.isPickingLogo, isFalse);
    },
  );
}
