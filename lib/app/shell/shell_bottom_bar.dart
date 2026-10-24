import 'package:flutter/material.dart';
import 'package:hairextensions/app/shell/shell_nav_item.dart';
import 'package:hairextensions/app/shell/shell_tab.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_scope.dart';
import 'package:hairextensions/shared/widgets/buttons/app_center_action_button.dart';

/// Two tabs on each side of the new-quote button. A tab whose feature flag
/// is off is hidden; its route is also blocked by the router.
class ShellBottomBar extends StatelessWidget {
  const ShellBottomBar({
    required this.currentTab,
    required this.onTabSelected,
    required this.onNewQuote,
    super.key,
  });

  final ShellTab currentTab;
  final ValueChanged<ShellTab> onTabSelected;
  final VoidCallback onNewQuote;

  static const int _leadingCount = 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = [
      for (final tab in ShellTab.values)
        if (tab.feature == null || FeatureFlagScope.isEnabled(context, tab.feature!)) tab,
    ];
    Widget item(ShellTab tab) => Expanded(
      child: ShellNavItem(tab: tab, isSelected: tab == currentTab, onTap: () => onTabSelected(tab)),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            ...visible.take(_leadingCount).map(item),
            AppCenterActionButton(semanticLabel: context.l10n.navNewQuote, onPressed: onNewQuote),
            ...visible.skip(_leadingCount).map(item),
          ],
        ),
      ),
    );
  }
}
