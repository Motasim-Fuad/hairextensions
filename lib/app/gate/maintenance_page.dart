import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';

/// Shown while Remote Config has maintenance on. Retry fetches flags again;
/// the router leaves this page by itself once maintenance is switched off.
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({required this.flags, super.key});

  final FeatureFlagService flags;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remoteMessage = flags.appStatus.maintenanceMessage.trim();
    return Scaffold(
      body: SafeArea(
        child: EmptyState(
          icon: AppIcon.clock,
          title: l10n.maintenanceTitle,
          message: remoteMessage.isEmpty ? l10n.maintenanceMessage : remoteMessage,
          actionLabel: l10n.actionRetry,
          actionIcon: AppIcon.refresh,
          onAction: () => unawaited(flags.refresh()),
        ),
      ),
    );
  }
}
