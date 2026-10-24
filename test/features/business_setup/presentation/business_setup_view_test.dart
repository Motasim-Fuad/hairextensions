import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_theme.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_flow.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/business_setup_view.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/business_profile_fixture.dart';
import '../../../helpers/mocks/mock_get_business_profile.dart';
import '../../../helpers/mocks/mock_permission_service.dart';
import '../../../helpers/mocks/mock_pick_business_logo.dart';
import '../../../helpers/mocks/mock_save_business_profile.dart';

void main() {
  late MockGetBusinessProfile getProfile;
  late MockSaveBusinessProfile saveProfile;
  late AppLocalizations l10n;

  setUpAll(() async {
    registerFallbackValue(BusinessProfileFixture.glamStrands);
    l10n = await AppLocalizations.delegate.load(AppLocales.fallback);
  });

  setUp(() {
    getProfile = MockGetBusinessProfile();
    saveProfile = MockSaveBusinessProfile();
    when(() => getProfile()).thenAnswer((_) async => const Right(null));
  });

  Future<void> pumpView(WidgetTester tester) async {
    final bloc = BusinessSetupBloc(getProfile, saveProfile, MockPickBusinessLogo(), MockPermissionService())
      ..add(const BusinessSetupStarted(SetupFlow.onboarding));
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocales.delegates,
        supportedLocales: AppLocales.supported,
        home: BlocProvider.value(value: bloc, child: const BusinessSetupView()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows step one with the Figma copy', (tester) async {
    await pumpView(tester);

    expect(find.text(l10n.setupStepLabel(1, 3)), findsOneWidget);
    expect(find.text(l10n.setupIdentityTitle), findsOneWidget);
    expect(find.text(l10n.actionContinue), findsOneWidget);
  });

  testWidgets('continue with an empty name shows the error under the field', (tester) async {
    await pumpView(tester);

    await tester.tap(find.text(l10n.actionContinue));
    await tester.pumpAndSettle();

    expect(find.text(l10n.fieldRequired), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a save failure appears as text below the button with retry', (tester) async {
    when(
      () => saveProfile(any(), completeSetup: any(named: 'completeSetup')),
    ).thenAnswer((_) async => const Left(LocalStorageFailure()));
    await pumpView(tester);

    await tester.enterText(find.byType(TextField).first, 'Glam Strands Studio');
    await tester.tap(find.text(l10n.actionContinue));
    await tester.pumpAndSettle();

    expect(find.text(l10n.errorLocalStorage), findsOneWidget);
    expect(find.text(l10n.actionRetry), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a valid step advances to contact details', (tester) async {
    when(
      () => saveProfile(any(), completeSetup: any(named: 'completeSetup')),
    ).thenAnswer((_) async => const Right(unit));
    await pumpView(tester);

    await tester.enterText(find.byType(TextField).first, 'Glam Strands Studio');
    await tester.tap(find.text(l10n.actionContinue));
    await tester.pumpAndSettle();

    expect(find.text(l10n.setupStepLabel(2, 3)), findsOneWidget);
    expect(find.text(l10n.setupContactTitle), findsOneWidget);
  });
}
