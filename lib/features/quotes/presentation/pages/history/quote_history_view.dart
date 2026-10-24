import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_filter.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_history_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/navigation/quote_navigation.dart';
import 'package:hairextensions/features/quotes/presentation/pages/history/widgets/quote_history_row.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/delete_quote_dialog.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';
import 'package:hairextensions/shared/widgets/inputs/app_choice_chips.dart';
import 'package:hairextensions/shared/widgets/inputs/app_search_field.dart';
import 'package:hairextensions/shared/widgets/inputs/choice_chip_variant.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_large_title.dart';
import 'package:hairextensions/shared/widgets/layout/overline_label.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_list.dart';

class QuoteHistoryView extends StatefulWidget {
  const QuoteHistoryView({super.key});

  @override
  State<QuoteHistoryView> createState() => _QuoteHistoryViewState();
}

class _QuoteHistoryViewState extends State<QuoteHistoryView> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear(QuoteHistoryCubit cubit) {
    _search.clear();
    cubit.clearSearch();
  }

  Future<void> _delete(Quote quote) async {
    final cubit = context.read<QuoteHistoryCubit>();
    if (await DeleteQuoteDialog.show(context, quote)) {
      await cubit.delete(quote.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<QuoteHistoryCubit>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<QuoteHistoryCubit, QuoteHistoryState>(
          builder: (context, state) {
            if (state.status == ViewStatus.loading) {
              return const SkeletonList();
            }
            if (state.quotes.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
                    child: AppLargeTitle(title: l10n.navQuotes),
                  ),
                  Expanded(
                    child: EmptyState(
                      icon: AppIcon.file,
                      title: l10n.quotesEmptyTitle,
                      message: l10n.quotesEmptyMessage,
                      actionLabel: l10n.actionCreateYourFirstQuote,
                      actionIcon: AppIcon.plus,
                      onAction: () => unawaited(context.startNewQuote()),
                    ),
                  ),
                ],
              );
            }
            final visible = state.visible;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.lg),
                  sliver: SliverList.list(
                    children: [
                      AppLargeTitle(title: l10n.navQuotes),
                      const SizedBox(height: AppSpacing.lg),
                      AppSearchField(controller: _search, hintText: l10n.quotesSearchHint, onChanged: cubit.search),
                      const SizedBox(height: AppSpacing.md),
                      AppChoiceChips<QuoteFilter>(
                        options: [
                          SegmentOption(value: QuoteFilter.all, label: l10n.filterAll),
                          SegmentOption(value: QuoteFilter.quotes, label: l10n.navQuotes),
                          SegmentOption(value: QuoteFilter.invoices, label: l10n.filterInvoices),
                          SegmentOption(value: QuoteFilter.thisMonth, label: l10n.filterThisMonth),
                        ],
                        selected: state.filter,
                        onChanged: cubit.selectFilter,
                        variant: ChoiceChipVariant.neutral,
                      ),
                    ],
                  ),
                ),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: AppIcon.search,
                      title: state.query.trim().isEmpty
                          ? l10n.quotesNoResultsFilter
                          : l10n.quotesNoResults(state.query.trim()),
                      message: l10n.quotesNoResultsMessage,
                      secondaryActionLabel: l10n.actionClearSearch,
                      onSecondaryAction: () => _clear(cubit),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
                    sliver: SliverList.list(children: _groupedRows(context, visible, state.now)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _groupedRows(BuildContext context, List<Quote> quotes, DateTime now) {
    final colors = context.colors;
    final rows = <Widget>[];
    String? month;
    for (final quote in quotes) {
      final label = DateFormatter.monthYear(quote.createdAt).toUpperCase();
      if (label != month) {
        month = label;
        rows.add(
          Padding(
            padding: EdgeInsets.only(top: rows.isEmpty ? 0 : AppSpacing.lg, bottom: AppSpacing.sm),
            child: OverlineLabel(text: label, color: colors.textTertiary),
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: QuoteHistoryRow(
            quote: quote,
            now: now,
            onTap: () => context.openQuote(quote.id),
            onCopy: () => unawaited(context.startNewQuote(template: quote)),
            onDelete: () => unawaited(_delete(quote)),
          ),
        ),
      );
    }
    return rows;
  }
}
