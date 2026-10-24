import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';

part 'staggered_entrance_state.dart';

/// Fades and lifts list items in once, staggered by [index]. Items beyond the
/// first screenful appear instantly so long lists never queue animations.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}
