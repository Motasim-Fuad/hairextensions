import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

part 'app_toast_overlay_state.dart';

/// Positions and animates a toast above the bottom navigation, then calls
/// [onDismissed] after [visibleFor].
class AppToastOverlay extends StatefulWidget {
  const AppToastOverlay({required this.child, required this.visibleFor, required this.onDismissed, super.key});

  final Widget child;
  final Duration visibleFor;
  final VoidCallback onDismissed;

  @override
  State<AppToastOverlay> createState() => _AppToastOverlayState();
}
