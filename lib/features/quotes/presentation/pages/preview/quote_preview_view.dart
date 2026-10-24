import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/preview/document_mode.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/preview/quote_preview_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/documents/quote_document_factory.dart';
import 'package:hairextensions/features/quotes/presentation/pages/preview/widgets/share_channel_button.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/quote_document_preview.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_loader.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_top_bar.dart';
import 'package:hairextensions/shared/widgets/layout/bottom_action_bar.dart';

class QuotePreviewView extends StatelessWidget {
  const QuotePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<QuotePreviewCubit, QuotePreviewState>(
      builder: (context, state) {
        final quote = state.quote;
        if (state.status == ViewStatus.loading || quote == null) {
          return const Scaffold(body: Center(child: AppLoader()));
        }
        final cubit = context.read<QuotePreviewCubit>();
        final document = state.mode == DocumentMode.client
            ? QuoteDocumentFactory.client(l10n, quote, state.profile)
            : QuoteDocumentFactory.internal(l10n, quote, state.profile);
        final onShare = state.isSharing ? null : () => unawaited(cubit.share(document));
        return Scaffold(
          appBar: AppTopBar(
            leading: const AppBackButton(),
            title: l10n.previewTitle,
            trailing: [
              AppIconButton(icon: AppIcon.download, semanticLabel: l10n.actionSave, onPressed: onShare),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxl),
            children: [
              AppSegmentedControl<DocumentMode>(
                options: [
                  SegmentOption(value: DocumentMode.client, label: l10n.previewClientPdf),
                  SegmentOption(value: DocumentMode.internal, label: l10n.previewCostSheet),
                ],
                selected: state.mode,
                onChanged: cubit.selectMode,
              ),
              const SizedBox(height: AppSpacing.lg),
              QuoteDocumentPreview(document: document, logoPath: state.profile?.logoPath),
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.lg,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShareChannelButton(icon: AppIcon.message, label: l10n.shareWhatsApp, onTap: onShare),
                    ShareChannelButton(icon: AppIcon.mail, label: l10n.actionEmail, onTap: onShare),
                    ShareChannelButton(icon: AppIcon.download, label: l10n.actionSave, onTap: onShare),
                    ShareChannelButton(icon: AppIcon.more, label: l10n.shareMore, onTap: onShare),
                  ],
                ),
                AppPrimaryButton(
                  label: l10n.actionSharePdf,
                  leadingIcon: AppIcon.share,
                  isLoading: state.isSharing,
                  onPressed: onShare,
                  errorText: state.failure == null ? null : l10n.errorPdf,
                  onRetry: state.failure == null ? null : onShare,
                  retryLabel: l10n.actionRetry,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
