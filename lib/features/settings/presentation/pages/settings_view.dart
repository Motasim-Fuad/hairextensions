import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_error.dart';
import 'package:hairextensions/features/settings/presentation/widgets/settings_group.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/layout/app_large_title.dart';
import 'package:hairextensions/shared/widgets/layout/app_list_tile.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';
import 'package:hairextensions/shared/widgets/media/business_logo.dart';

/// Design 4.4.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<SettingsCubit>();
    Future<void> confirmLogout() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Log out'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      try {
        await cubit.logout();

        if (!context.mounted) return;

        context.goNamed(AppRoutes.login);
      } catch (_) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to log out. Please try again.'),
          ),
        );
      }
    }
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();
            final profile = state.profile;
            final businessName = profile?.businessName ?? l10n.sampleBusinessName;
            void editProfile() => context.goNamed(AppRoutes.editBusinessProfile);
            void editDefaults() => context.goNamed(AppRoutes.editQuoteDefaults);
            void openLibrary() => context.goNamed(AppRoutes.library);
            void openPaywall() => unawaited(context.pushNamed<void>(AppRoutes.paywall));
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxl),
              children: [
                AppLargeTitle(title: l10n.navSettings),
                const SizedBox(height: AppSpacing.lg),
                SectionCard(
                  onTap: editProfile,
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      BusinessLogo(businessName: businessName, logoPath: profile?.logoPath),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(businessName, style: AppTextStyles.planTitle.copyWith(color: colors.textPrimary)),
                            Text(
                              profile?.email ?? l10n.fieldEmailHint,
                              style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                            ),
                          ],
                        ),
                      ),
                      AppIconButton(icon: AppIcon.pen, semanticLabel: l10n.actionEdit, onPressed: editProfile),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DecoratedBox(
                  decoration: BoxDecoration(gradient: colors.heroGradient, borderRadius: AppRadius.lgAll),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      spacing: AppSpacing.md,
                      children: [
                        AppSvgIcon(AppIcon.crown, size: AppSizes.iconLg, color: colors.gold),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.isPro ? l10n.settingsProActive : l10n.settingsProInactive,
                                style: AppTextStyles.rowTitle.copyWith(color: colors.onPrimary),
                              ),
                              Text(
                                state.isPro ? l10n.settingsProActiveDetail : l10n.settingsProInactiveDetail,
                                style: AppTextStyles.caption.copyWith(color: colors.onPrimary),
                              ),
                            ],
                          ),
                        ),
                        AppLinkButton(
                          label: state.isPro ? l10n.actionManage : l10n.actionUpgrade,
                          color: colors.onPrimary,
                          onPressed: state.isPro ? () => unawaited(cubit.manageSubscription()) : openPaywall,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.errorKind != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  InlineErrorText(
                    message: state.errorKind == SettingsError.link ? l10n.errorOpenLink : l10n.paywallUnavailable,
                  ),
                ],
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupBusiness,
                  children: [
                    AppListTile(icon: AppIcon.briefcase, title: l10n.settingsBusinessProfile, onTap: editProfile),
                    AppListTile(icon: AppIcon.palette, title: l10n.settingsPdfBranding, onTap: editProfile),
                    AppListTile(
                      icon: AppIcon.percent,
                      title: l10n.settingsQuoteDefaults,
                      trailingText: profile == null
                          ? null
                          : [
                        profile.currencyCode,
                        l10n.percentValue(PercentFormatter.format(profile.taxRatePercent)),
                      ].join(l10n.separatorDot),
                      onTap: editDefaults,
                    ),
                    AppListTile(
                      icon: AppIcon.hash,
                      title: l10n.settingsNumbering,
                      trailingText: profile == null
                          ? null
                          : l10n.numberingValue(profile.quotePrefix, profile.invoicePrefix),
                      onTap: editDefaults,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupLibrary,
                  children: [
                    AppListTile(
                      icon: AppIcon.package,
                      title: l10n.libraryProducts,
                      trailingText: '${state.productCount}',
                      onTap: openLibrary,
                    ),
                    AppListTile(
                      icon: AppIcon.wallet,
                      title: l10n.labelMaterials,
                      trailingText: '${state.materialCount}',
                      onTap: openLibrary,
                    ),
                    AppListTile(
                      icon: AppIcon.scissors,
                      title: l10n.settingsServiceTemplates,
                      trailingText: '${state.serviceCount}',
                      onTap: openLibrary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupSubscription,
                  children: [
                    AppListTile(
                      icon: AppIcon.crown,
                      title: l10n.settingsManageSubscription,
                      onTap: state.isPro ? () => unawaited(cubit.manageSubscription()) : openPaywall,
                    ),
                    AppListTile(
                      icon: AppIcon.refresh,
                      title: l10n.actionRestorePurchases,
                      onTap: () => unawaited(cubit.restore()),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupAbout,
                  children: [
                    AppListTile(
                      icon: AppIcon.shield,
                      title: l10n.settingsPrivacy,
                      onTap: () => unawaited(cubit.openPrivacy()),
                    ),
                    AppListTile(
                      icon: AppIcon.file,
                      title: l10n.settingsTerms,
                      onTap: () => unawaited(cubit.openTerms()),
                    ),
                    AppListTile(
                      icon: AppIcon.help,
                      title: l10n.settingsSupport,
                      onTap: () => unawaited(cubit.contactSupport()),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: 'Account',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: confirmLogout,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                Text(
                  state.version == null ? l10n.appName : l10n.settingsVersion(state.version!),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                ),
              ],
            );
          },
        ),
      ),
    );


  }
}
