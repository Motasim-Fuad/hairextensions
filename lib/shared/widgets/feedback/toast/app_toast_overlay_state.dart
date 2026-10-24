part of 'app_toast_overlay.dart';

class _AppToastOverlayState extends State<AppToastOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: AppMotion.medium);
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: AppMotion.standard);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = context.motion(AppMotion.medium);
    if (_timer == null) {
      unawaited(_controller.forward());
      _timer = Timer(widget.visibleFor, _hide);
    }
  }

  Future<void> _hide() async {
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSizes.bottomBarHeight + AppSpacing.lg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxToastWidth),
            child: FadeTransition(
              opacity: _curve,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, AppMotion.entranceSlideOffset),
                  end: Offset.zero,
                ).animate(_curve),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
