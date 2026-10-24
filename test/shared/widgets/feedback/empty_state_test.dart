import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders texts and triggers both actions', (tester) async {
    var primary = 0;
    var secondary = 0;
    await tester.pumpApp(
      EmptyState(
        icon: AppIcon.file,
        title: 'No quotes yet',
        message: 'Create your first quote.',
        actionLabel: 'Create your first quote',
        onAction: () => primary++,
        secondaryActionLabel: 'Clear search',
        onSecondaryAction: () => secondary++,
      ),
    );

    await tester.tap(find.text('Create your first quote'));
    await tester.tap(find.text('Clear search'));

    expect(find.text('No quotes yet'), findsOneWidget);
    expect(primary, 1);
    expect(secondary, 1);
  });
}
