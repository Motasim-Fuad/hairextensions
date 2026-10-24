part of 'onboarding_view.dart';

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  Timer? _splashTimer;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(AppMotion.splashHold, () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final target = context.read<OnboardingCubit>().state + 1;
    final duration = context.motion(AppMotion.page);
    if (duration == Duration.zero) {
      _controller.jumpToPage(target);
    } else {
      unawaited(_controller.animateToPage(target, duration: duration, curve: AppMotion.standard));
    }
  }

  Future<void> _finish() async {
    await context.read<OnboardingCubit>().finish();
    if (mounted) {
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<OnboardingCubit>();
    return AnimatedSwitcher(
      duration: context.motion(AppMotion.slow),
      child: _showSplash
          ? const BrandSplash(key: ValueKey('splash'))
          : Scaffold(
              key: const ValueKey('slides'),
              body: SafeArea(
                child: Column(
                  children: [
                    OnboardingTopBar(onSkip: _finish),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        onPageChanged: cubit.showPage,
                        children: [
                          OnboardingSlide(
                            illustration: const CostPerGramShowcase(),
                            title: l10n.onboardingCostTitle,
                            body: l10n.onboardingCostBody,
                          ),
                          OnboardingSlide(
                            illustration: const QuoteBreakdownShowcase(),
                            title: l10n.onboardingQuoteTitle,
                            body: l10n.onboardingQuoteBody,
                          ),
                          OnboardingSlide(
                            illustration: const BrandedQuoteShowcase(),
                            title: l10n.onboardingBrandTitle,
                            body: l10n.onboardingBrandBody,
                          ),
                        ],
                      ),
                    ),
                    OnboardingBottomActions(onNext: _next, onFinish: _finish),
                  ],
                ),
              ),
            ),
    );
  }
}
