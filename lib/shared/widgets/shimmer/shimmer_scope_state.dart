part of 'shimmer_scope.dart';

class _ShimmerScopeState extends State<ShimmerScope> with SingleTickerProviderStateMixin {
  static const List<double> _stops = [0.35, 0.5, 0.65];
  static const Alignment _begin = Alignment(-1, -0.3);
  static const Alignment _end = Alignment(1, 0.3);

  late final AnimationController _controller = AnimationController(vsync: this, duration: AppMotion.shimmerCycle);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shimmerColors = [colors.shimmerBase, colors.shimmerHighlight, colors.shimmerBase];
    return Semantics(
      label: context.l10n.loadingLabel,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            child: widget.child,
            builder: (context, child) {
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => LinearGradient(
                  colors: shimmerColors,
                  stops: _stops,
                  begin: _begin,
                  end: _end,
                  transform: SlidingGradientTransform(_controller.value * 2 - 1),
                ).createShader(bounds),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
