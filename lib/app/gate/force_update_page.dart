import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';
import 'package:hairextensions/shared/widgets/layout/bottom_action_bar.dart';

part 'force_update_page_state.dart';

/// Blocks the app below the minimum supported version. A store link that
/// fails to open shows an inline error under the button.
class ForceUpdatePage extends StatefulWidget {
  const ForceUpdatePage({required this.gate, required this.launcher, super.key});

  final AppGateService gate;
  final LinkLauncher launcher;

  @override
  State<ForceUpdatePage> createState() => _ForceUpdatePageState();
}
