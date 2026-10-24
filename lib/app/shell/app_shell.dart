import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/app/shell/shell_bottom_bar.dart';
import 'package:hairextensions/app/shell/shell_tab.dart';
import 'package:hairextensions/core/analytics/screen_view_tracker.dart';
import 'package:hairextensions/core/contracts/pro_gate.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/shared/widgets/feedback/offline_banner.dart';

/// Tabs keep their own navigation stacks (indexed stack), so switching tabs
/// never rebuilds or refetches a tab that was already open.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, required this.screenViews, super.key});

  final StatefulNavigationShell navigationShell;
  final ScreenViewTracker screenViews;

  void _select(ShellTab tab) {
    navigationShell.goBranch(tab.index, initialLocation: tab.index == navigationShell.currentIndex);
    screenViews.track(tab.routeName);
  }

  Future<void> _startNewQuote(BuildContext context) async {
    final allowed = await getIt<ProGate>().ensurePro(context);
    if (allowed && context.mounted) {
      await context.pushNamed<void>(AppRoutes.newQuote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: ShellBottomBar(
        currentTab: ShellTab.values[navigationShell.currentIndex],
        onTabSelected: _select,
        onNewQuote: () => unawaited(_startNewQuote(context)),
      ),
    );
  }
}
