import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/paywall_feature_row.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/paywall_footer.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/paywall_hero.dart';
import 'package:hairextensions/features/paywall/presentation/widgets/paywall_plans.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';

/// Closing or unlocking continues to setup on first launch and goes back
/// everywhere else.
class PaywallView extends StatelessWidget {
  const PaywallView({super.key});

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) => !previous.isUnlocked && current.isUnlocked,
      listener: (context, _) => _close(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.section,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AppIconButton(
                          icon: AppIcon.close,
                          semanticLabel: l10n.actionClose,
                          dimension: AppSizes.closeButton,
                          iconSize: AppSizes.iconSm,
                          onPressed: () => _close(context),
                        ),
                      ),
                      const PaywallHero(),
                      Column(
                        spacing: AppSpacing.md,
                        children: [
                          PaywallFeatureRow(label: l10n.paywallFeatureUnlimited),
                          PaywallFeatureRow(label: l10n.paywallFeatureBranding),
                          PaywallFeatureRow(label: l10n.paywallFeatureLibrary),
                          PaywallFeatureRow(label: l10n.paywallFeaturePaymentLink),
                          PaywallFeatureRow(label: l10n.paywallFeatureProfit),
                        ],
                      ),
                      const PaywallPlans(),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.sm),
                child: PaywallFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
