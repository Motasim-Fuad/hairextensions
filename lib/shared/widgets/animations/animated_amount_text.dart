import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';

/// Rolls a money amount from its previous value to the new one, for live
/// totals. Shows the final value immediately on first build.
class AnimatedAmountText extends StatelessWidget {
  const AnimatedAmountText({required this.minor, required this.format, super.key, this.style});

  final int minor;
  final String Function(int minor) format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: minor.toDouble()),
      duration: context.motion(AppMotion.slow),
      curve: AppMotion.standard,
      builder: (context, value, _) => Text(format(value.round()), style: style),
    );
  }
}
