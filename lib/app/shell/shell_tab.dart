import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

/// Bottom navigation tabs. Declaration order must match the shell branch
/// order in the router, because the index is shared.
enum ShellTab {
  home(AppRoutes.home, AppIcon.home, AppIcon.home),
  quotes(AppRoutes.quotes, AppIcon.file, AppIcon.file),
  library(AppRoutes.library, AppIcon.package, AppIcon.package, feature: FeatureKey.library),
  settings(AppRoutes.settings, AppIcon.sliders, AppIcon.sliders);

  const ShellTab(this.routeName, this.icon, this.selectedIcon, {this.feature});

  final String routeName;
  final AppIcon icon;
  final AppIcon selectedIcon;
  final FeatureKey? feature;

  String label(AppLocalizations l10n) => switch (this) {
    ShellTab.home => l10n.navHome,
    ShellTab.quotes => l10n.navQuotes,
    ShellTab.library => l10n.navLibrary,
    ShellTab.settings => l10n.navSettings,
  };
}
