import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';

/// Back (or close) for pushed screens. A screen opened with `go` has nothing
/// to pop, so it falls back to home instead of doing nothing.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.icon = AppIcon.chevronLeft});

  final AppIcon icon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppIconButton(
      icon: icon,
      semanticLabel: icon == AppIcon.close ? l10n.actionClose : l10n.actionBack,
      onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.homePath),
    );
  }
}
