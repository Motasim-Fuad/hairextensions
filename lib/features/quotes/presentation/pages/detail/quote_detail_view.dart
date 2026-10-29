import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity_type.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/detail/quote_detail_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_status_text.dart';
import 'package:hairextensions/features/quotes/presentation/navigation/quote_navigation.dart';
import 'package:hairextensions/features/quotes/presentation/pages/detail/widgets/quote_activity_tile.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/amount_stat.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/delete_quote_dialog.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_outline_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_soft_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_loader.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/layout/app_top_bar.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/layout/overline_label.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';

class QuoteDetailView extends StatelessWidget {
  const QuoteDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteDetailCubit, QuoteDetailState>(
      listenWhen: (previous, current) => !previous.isGone && current.isGone,
      listener: (context, _) =>
          context.canPop() ? context.pop() : context.go(AppRoutes.homePath),
      builder: (context, state) {
        final quote = state.quote;
        if (state.failure != null && quote == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Document')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure!.localizedMessage(context.l10n),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: context.read<QuoteDetailCubit>().retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.status == ViewStatus.loading || quote == null) {
          return const Scaffold(body: Center(child: AppLoader()));
        }
        return _DetailScaffold(
          quote: quote,
          errorText: state.failure?.localizedMessage(context.l10n),
        );
      },
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.quote, this.errorText});

  final Quote quote;
  final String? errorText;

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<QuoteDetailCubit>();
    if (await DeleteQuoteDialog.show(context, quote)) {
      await cubit.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<QuoteDetailCubit>();
    final totals = quote.totals;
    final currency = quote.currencyCode;
    String money(int minor) =>
        MoneyFormatter.format(minor, currency, showDecimals: false);
    return Scaffold(
      appBar: AppTopBar(
        leading: const AppBackButton(),
        title: quote.number,
        subtitle: l10n.quoteCreatedValid(
          DateFormatter.dayMonth(quote.createdAt),
          DateFormatter.dayMonth(quote.validUntil),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        children: [
          if (!quote.status.isInvoice)
            AppOutlineButton(
              label: l10n.actionEdit,
              leadingIcon: AppIcon.pen,
              onPressed: () => unawaited(
                context.pushNamed<void>(
                  AppRoutes.newQuote,
                  queryParameters: {'edit': 'true'},
                  extra: quote,
                ),
              ),
            ),
          if (quote.serverStatus != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Status: ${quote.serverStatus}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final status
                    in quote.status.isInvoice
                        ? const ['unpaid', 'deposit_paid', 'paid']
                        : switch (quote.serverStatus) {
                            'draft' => const ['sent', 'accepted', 'declined'],
                            'sent' => const ['draft', 'accepted', 'declined'],
                            'accepted' => const ['sent', 'declined'],
                            'declined' => const ['draft', 'sent'],
                            _ => const <String>[],
                          })
                  ActionChip(
                    label: Text(status.replaceAll('_', ' ')),
                    onPressed: status == quote.serverStatus
                        ? null
                        : () => unawaited(cubit.updateStatus(status)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.lg,
              children: [
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    IconBadge(
                      icon: AppIcon.user,
                      size: AppSizes.avatar,
                      background: colors.primarySurface,
                      foreground: colors.primary,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quote.clientName,
                            style: AppTextStyles.rowTitle.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          if (quote.clientPhone != null)
                            Text(
                              quote.clientPhone!,
                              style: AppTextStyles.caption.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppStatusChip(
                      label: quote.status.label(l10n),
                      tone: quote.status.tone,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AmountStat(
                        label: l10n.statTotal,
                        value: money(totals.totalMinor),
                      ),
                    ),
                    Expanded(
                      child: AmountStat(
                        label: l10n.statDeposit,
                        value: money(totals.depositMinor),
                      ),
                    ),
                    Expanded(
                      child: AmountStat(
                        label: l10n.statBalance,
                        value: money(totals.balanceMinor),
                        valueColor: colors.primary,
                      ),
                    ),
                  ],
                ),
                Divider(height: AppSizes.borderThin, color: colors.border),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.quoteLineSummary(
                          quote.lines.length,
                          money(totals.vatMinor),
                        ),
                        style: AppTextStyles.detail.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    AppLinkButton(
                      label: l10n.actionView,
                      onPressed: () => context.openQuotePreview(quote.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: l10n.actionSharePdf,
            leadingIcon: AppIcon.share,
            onPressed: () => context.openQuotePreview(quote.id),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            spacing: AppSpacing.md,
            children: [
              if (quote.status != QuoteStatus.paid)
                Expanded(
                  child: AppSoftButton(
                    label: quote.status == QuoteStatus.quote
                        ? l10n.actionConvertToInvoice
                        : l10n.actionMarkPaid,
                    leadingIcon: quote.status == QuoteStatus.quote
                        ? AppIcon.file
                        : AppIcon.check,
                    isCompact: true,
                    onPressed: () => unawaited(
                      quote.status == QuoteStatus.quote
                          ? cubit.convertToInvoice()
                          : cubit.markPaid(),
                    ),
                  ),
                ),
              Expanded(
                child: AppOutlineButton(
                  label: l10n.actionDuplicate,
                  leadingIcon: AppIcon.copy,
                  onPressed: () async {
                    if (quote.status.isInvoice) {
                      await context.startNewQuote(template: quote);
                    } else {
                      final created = await cubit.duplicate();
                      if (context.mounted && created != null)
                        context.openQuote(created.id);
                    }
                  },
                ),
              ),
            ],
          ),
          if (errorText != null) ...[
            const SizedBox(height: AppSpacing.sm),
            InlineErrorText(message: errorText),
          ],
          const SizedBox(height: AppSpacing.xxl),
          OverlineLabel(text: l10n.quoteActivity, color: colors.textTertiary),
          const SizedBox(height: AppSpacing.sm),
          SectionCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (final entry in quote.activity)
                  QuoteActivityTile(
                    icon: _activityIcon(entry.type),
                    title: _activityTitle(l10n, entry.type),
                    subtitle: [
                      DateFormatter.dayMonthYear(entry.at),
                      DateFormatter.time(entry.at),
                    ].join(l10n.separatorDot),
                  ),
                QuoteActivityTile(
                  icon: AppIcon.clock,
                  title: l10n.activityValidUntil,
                  subtitle: DateFormatter.dayMonthYear(quote.validUntil),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: AppLinkButton(
              label: l10n.actionDeleteQuote,
              icon: AppIcon.trash,
              color: colors.danger,
              onPressed: () => unawaited(_delete(context)),
            ),
          ),
        ],
      ),
    );
  }

  AppIcon _activityIcon(QuoteActivityType type) => switch (type) {
    QuoteActivityType.created => AppIcon.file,
    QuoteActivityType.shared => AppIcon.message,
    QuoteActivityType.convertedToInvoice => AppIcon.refresh,
    QuoteActivityType.markedPaid => AppIcon.check,
  };

  String _activityTitle(AppLocalizations l10n, QuoteActivityType type) =>
      switch (type) {
        QuoteActivityType.created => l10n.activityCreated,
        QuoteActivityType.shared => l10n.activityShared,
        QuoteActivityType.convertedToInvoice => l10n.activityConverted,
        QuoteActivityType.markedPaid => l10n.activityPaid,
      };
}
