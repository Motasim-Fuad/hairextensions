import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/home/home_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/navigation/quote_navigation.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/widgets/home_header.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/widgets/home_hero_card.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/widgets/home_quick_action.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/widgets/home_skeleton.dart';
import 'package:hairextensions/features/quotes/presentation/pages/home/widgets/home_stat_tile.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/quote_list_tile.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/animations/staggered_entrance.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';
import 'package:hairextensions/shared/widgets/layout/section_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == ViewStatus.loading) {
              return const HomeSkeleton();
            }
            return _HomeContent(state: state);
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = state.profile;
    final summary = state.summary;
    final currency = state.currency;
    final latest = state.latest;
    final sections = <Widget>[
      HomeHeader(
        businessName: profile?.businessName ?? l10n.sampleBusinessName,
        greetingName: profile?.greetingName ?? l10n.sampleOwnerName,
        logoPath: profile?.logoPath,
        hour: state.now.hour,
        onSearch: () => context.goNamed(AppRoutes.quotes),
      ),
      if (state.loadError != null)
        Column(
          children: [
            Text(state.loadError!, textAlign: TextAlign.center),
            TextButton(
              onPressed: context.read<HomeCubit>().retryDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      if (summary != null) ...[
        HomeHeroCard(summary: summary, currency: currency),
        Row(
          spacing: AppSpacing.md,
          children: [
            Expanded(
              child: HomeStatTile(
                label: l10n.homeStatQuotes,
                value: '${summary.quoteCount}',
              ),
            ),
            Expanded(
              child: HomeStatTile(
                label: l10n.homeStatInvoices,
                value: '${summary.invoiceCount}',
              ),
            ),
            Expanded(
              child: HomeStatTile(
                label: 'Collected',
                value: MoneyFormatter.compact(summary.depositsMinor),
              ),
            ),
          ],
        ),
      ],
      Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: HomeQuickAction(
              icon: AppIcon.plus,
              label: l10n.navNewQuote,
              onTap: () => unawaited(context.startNewQuote()),
            ),
          ),
          Expanded(
            child: HomeQuickAction(
              icon: AppIcon.package,
              label: l10n.homeAddProduct,
              onTap: () =>
                  unawaited(context.pushNamed<void>(AppRoutes.productForm)),
            ),
          ),
          Expanded(
            child: HomeQuickAction(
              icon: AppIcon.copy,
              label: l10n.homeDuplicateLast,
              onTap: latest == null
                  ? () {}
                  : () => unawaited(context.startNewQuote(template: latest)),
            ),
          ),
        ],
      ),
      SectionHeader(
        title: l10n.homeRecentQuotes,
        actionLabel: l10n.actionSeeAll,
        onAction: () => context.goNamed(AppRoutes.quotes),
      ),
      if (state.recent.isEmpty)
        EmptyState(
          icon: AppIcon.file,
          title: l10n.quotesEmptyTitle,
          message: l10n.quotesEmptyMessage,
        )
      else
        Column(
          spacing: AppSpacing.md,
          children: [
            for (final quote in state.recent)
              QuoteListTile(
                quote: quote,
                now: state.now,
                onTap: () => context.openQuote(quote.id),
              ),
          ],
        ),
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.section),
      itemBuilder: (_, index) =>
          StaggeredEntrance(index: index, child: sections[index]),
    );
  }
}
