import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const options = [
    SegmentOption(value: 'quote', label: 'Quote'),
    SegmentOption(value: 'invoice', label: 'Invoice'),
  ];

  testWidgets('reports a newly selected segment', (tester) async {
    String? changed;
    await tester.pumpApp(
      AppSegmentedControl<String>(options: options, selected: 'quote', onChanged: (value) => changed = value),
    );

    await tester.tap(find.text('Invoice'));

    expect(changed, 'invoice');
  });

  testWidgets('does not report the already selected segment', (tester) async {
    String? changed;
    await tester.pumpApp(
      AppSegmentedControl<String>(options: options, selected: 'quote', onChanged: (value) => changed = value),
    );

    await tester.tap(find.text('Quote'));

    expect(changed, isNull);
  });
}
