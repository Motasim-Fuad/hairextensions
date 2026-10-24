import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/shared/widgets/feedback/toast/app_toast_presenter.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows only when called and dismisses itself', (tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => AppToastPresenter.show(
            context,
            message: 'Saved for later',
            visibleFor: const Duration(seconds: 1),
          ),
          child: const Text('show'),
        ),
      ),
    );
    expect(find.text('Saved for later'), findsNothing);

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('Saved for later'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Saved for later'), findsNothing);
  });
}
