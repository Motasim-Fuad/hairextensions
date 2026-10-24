import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';

/// Short fade with a small upward drift for top-level destinations. Only
/// opacity and translation animate, so it stays on the raster thread.
class FadeSlidePage<T> extends CustomTransitionPage<T> {
  FadeSlidePage({required GoRouterState state, required super.child})
    : super(
        key: state.pageKey,
        name: state.name ?? state.path,
        arguments: state.extra,
        transitionDuration: AppMotion.page,
        reverseTransitionDuration: AppMotion.page,
        transitionsBuilder: _build,
      );

  static final Animatable<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, AppMotion.pageSlideOffset),
    end: Offset.zero,
  ).chain(CurveTween(curve: AppMotion.standard));

  static Widget _build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (context.reduceMotion) {
      return child;
    }
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: AppMotion.standard),
      child: SlideTransition(position: animation.drive(_offset), child: child),
    );
  }
}
