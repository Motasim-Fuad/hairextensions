import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/widgets/setup_complete_actions.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/widgets/setup_complete_summary.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/widgets/setup_success_badge.dart';
import 'package:hairextensions/shared/widgets/animations/staggered_entrance.dart';
import 'package:hairextensions/shared/widgets/responsive/max_width_box.dart';

class SetupCompleteView extends StatelessWidget {
  const SetupCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.huge),
          child: MaxWidthBox(
            child: Column(
              children: [
                StaggeredEntrance(index: 0, child: SetupSuccessBadge()),
                SizedBox(height: AppSpacing.xxl),
                StaggeredEntrance(index: 1, child: SetupCompleteSummary()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SetupCompleteActions(),
    );
  }
}
