import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';

/// Full-page fallback for unknown routes and unrecoverable screen failures.
class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({required this.onGoHome, super.key});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: EmptyState(
          icon: AppIcon.alert,
          title: l10n.errorScreenTitle,
          message: l10n.errorScreenMessage,
          actionLabel: l10n.actionGoHome,
          actionIcon: AppIcon.home,
          onAction: onGoHome,
        ),
      ),
    );
  }
}
