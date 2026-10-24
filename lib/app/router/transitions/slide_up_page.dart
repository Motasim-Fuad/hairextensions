import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';

/// Full-screen flows opened from anywhere, such as the quote builder.
class SlideUpPage<T> extends CustomTransitionPage<T> {
  SlideUpPage({required GoRouterState state, required super.child})
    : super(
        key: state.pageKey,
        name: state.name ?? state.path,
        arguments: state.extra,
        fullscreenDialog: true,
        transitionDuration: AppMotion.slow,
        reverseTransitionDuration: AppMotion.medium,
        transitionsBuilder: _build,
      );

  static final Animatable<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).chain(CurveTween(curve: AppMotion.emphasized));

  static Widget _build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (context.reduceMotion) {
      return child;
    }
    return SlideTransition(position: animation.drive(_offset), child: child);
  }
}
