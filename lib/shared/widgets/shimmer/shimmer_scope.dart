import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/shared/widgets/shimmer/sliding_gradient_transform.dart';

part 'shimmer_scope_state.dart';

/// Wrap a whole page skeleton once. One controller and one shader paint the
/// shine across every bone below, instead of one animation per bone. The
/// ticker pauses automatically when the route is hidden and the shine is
/// static when the user prefers reduced motion.
class ShimmerScope extends StatefulWidget {
  const ShimmerScope({required this.child, super.key});

  final Widget child;

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}
