import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';

/// Small pill such as Quote, Invoice, Paid or Draft.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({required this.label, required this.tone, super.key});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      StatusTone.primary => (colors.primarySoft, colors.primaryStrong),
      StatusTone.gold => (colors.goldSoft, colors.goldDeep),
      StatusTone.warning => (colors.warningSoft, colors.warning),
      StatusTone.success => (colors.successSoft, colors.success),
      StatusTone.danger => (colors.dangerSoft, colors.danger),
      StatusTone.neutral => (colors.surfaceMuted, colors.textSecondary),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.pillAll),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.chipX, vertical: AppSpacing.xs),
        child: Text(label, style: AppTextStyles.chip.copyWith(color: foreground)),
      ),
    );
  }
}
