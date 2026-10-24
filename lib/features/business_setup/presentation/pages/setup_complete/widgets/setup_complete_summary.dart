import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/setup_summary/setup_summary_cubit.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/setup_summary/setup_summary_status.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/widgets/quote_preview_card.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/setup_complete/widgets/quote_preview_skeleton.dart';
import 'package:hairextensions/shared/widgets/animations/fade_slide_switcher.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

class SetupCompleteSummary extends StatelessWidget {
  const SetupCompleteSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupSummaryCubit, SetupSummaryState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final profile = state.profile;
        final failure = state.failure;
        return FadeSlideSwitcher(
          child: switch (state.status) {
            SetupSummaryStatus.loading => const QuotePreviewSkeleton(key: ValueKey(SetupSummaryStatus.loading)),
            SetupSummaryStatus.failure => InlineErrorText(
              key: const ValueKey(SetupSummaryStatus.failure),
              message: failure == null ? l10n.errorUnknown : failure.localizedMessage(l10n),
              actionLabel: l10n.actionRetry,
              onAction: () => context.read<SetupSummaryCubit>().load(),
            ),
            SetupSummaryStatus.ready => Column(
              key: const ValueKey(SetupSummaryStatus.ready),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.setupCompleteTitle(profile?.greetingName ?? ''),
                    style: context.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.setupCompleteSubtitle,
                  style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (profile != null) QuotePreviewCard(profile: profile),
              ],
            ),
          },
        );
      },
    );
  }
}
