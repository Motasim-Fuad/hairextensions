import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpApp(AppPrimaryButton(label: 'Continue', onPressed: () => taps++));

    await tester.tap(find.text('Continue'));

    expect(taps, 1);
  });

  testWidgets('shows the error text directly below the button', (tester) async {
    await tester.pumpApp(
      AppPrimaryButton(label: 'Generate PDF', onPressed: () {}, errorText: 'Could not generate PDF.'),
    );
    await tester.pumpAndSettle();

    final buttonBottom = tester.getBottomLeft(find.byType(FilledButton)).dy;
    final errorTop = tester.getTopLeft(find.text('Could not generate PDF.')).dy;

    expect(errorTop, greaterThan(buttonBottom));
  });

  testWidgets('ignores taps and hides the label while loading', (tester) async {
    var taps = 0;
    await tester.pumpApp(AppPrimaryButton(label: 'Save', onPressed: () => taps++, isLoading: true));

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);

    expect(taps, 0);
    expect(find.text('Save'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
