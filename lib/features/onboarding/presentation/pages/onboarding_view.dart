import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/brand_splash.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/branded_quote_showcase.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/cost_per_gram_showcase.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/onboarding_bottom_actions.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/onboarding_slide.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/onboarding_top_bar.dart';
import 'package:hairextensions/features/onboarding/presentation/widgets/quote_breakdown_showcase.dart';

part 'onboarding_view_state.dart';

/// First launch only: the brand splash, then three swipeable slides. Skip and
/// Get started both continue to log in (new users switch to registration from
/// there), which then continues to the paywall.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}
