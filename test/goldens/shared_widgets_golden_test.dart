@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/app_theme.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/buttons/app_outline_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_soft_button.dart';
import 'package:hairextensions/shared/widgets/buttons/dashed_add_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chips.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_list_tile.dart';

import '../helpers/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  Widget gallery(ThemeData theme) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      localizationsDelegates: AppLocales.delegates,
      supportedLocales: AppLocales.supported,
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            AppPrimaryButton(label: 'Continue', trailingIcon: AppIcon.chevronRight, onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppPrimaryButton(
              label: 'Share PDF',
              onPressed: () {},
              errorText: 'Could not generate PDF.',
              retryLabel: 'Retry',
              onRetry: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            AppSoftButton(label: 'Convert to invoice', leadingIcon: AppIcon.file, onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppOutlineButton(label: 'Save', leadingIcon: AppIcon.check, onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            DashedAddButton(label: 'Add hair', onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppSegmentedControl<int>(
              options: const [
                SegmentOption(value: 0, label: 'Whole pack'),
                SegmentOption(value: 1, label: 'Exact grams'),
              ],
              selected: 0,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.md),
            AppChoiceChips<int>(
              options: const [
                SegmentOption(value: 0, label: 'Tape-in'),
                SegmentOption(value: 1, label: 'Keratin'),
                SegmentOption(value: 2, label: 'Weft'),
              ],
              selected: 0,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.md),
            const Wrap(
              spacing: AppSpacing.sm,
              children: [
                AppStatusChip(label: 'Quote', tone: StatusTone.primary),
                AppStatusChip(label: 'Invoice', tone: StatusTone.warning),
                AppStatusChip(label: 'Paid', tone: StatusTone.success),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const AppTextField(
              label: 'Business name',
              isRequired: true,
              hintText: 'Glam Strands Studio',
              errorText: 'This field is required',
            ),
            const SizedBox(height: AppSpacing.md),
            const SkeletonListTile(),
          ],
        ),
      ),
    );
  }

  testWidgets('shared widgets light', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(gallery(AppTheme.light()));
    await tester.pumpAndSettle();

    await expectLater(find.byType(MaterialApp), matchesGoldenFile('shared_widgets_light.png'));
  });

  testWidgets('shared widgets dark', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(gallery(AppTheme.dark()));
    await tester.pumpAndSettle();

    await expectLater(find.byType(MaterialApp), matchesGoldenFile('shared_widgets_dark.png'));
  });
}
