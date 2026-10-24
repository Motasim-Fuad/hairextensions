part of 'staggered_entrance.dart';

class _StaggeredEntranceState extends State<StaggeredEntrance> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: AppMotion.medium);
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: AppMotion.standard);
  late final Animation<Offset> _offset = Tween(
    begin: const Offset(0, AppMotion.entranceSlideOffset),
    end: Offset.zero,
  ).animate(_curve);
  Timer? _delay;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    if (context.reduceMotion || widget.index >= AppMotion.staggerMaxItems) {
      _controller.value = 1;
      return;
    }
    _delay = Timer(AppMotion.staggerStep * widget.index, () => unawaited(_controller.forward()));
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCompleted) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
