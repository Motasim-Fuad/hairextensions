import 'package:hairextensions/features/settings/presentation/pages/business_defaults/business_defaults_page.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_error.dart';
import 'package:hairextensions/features/settings/presentation/widgets/settings_group.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/layout/app_large_title.dart';
import 'package:hairextensions/shared/widgets/layout/app_list_tile.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';
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
          const SnackBar(content: Text('Unable to log out. Please try again.')),
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
            final businessName =
                profile?.businessName ?? l10n.sampleBusinessName;
            void editProfile() =>
                context.goNamed(AppRoutes.editBusinessProfile);
            void editDefaults() => context.goNamed(AppRoutes.editQuoteDefaults);
            void openLibrary() => context.goNamed(AppRoutes.library);
            void openPaywall() =>
                unawaited(context.pushNamed<void>(AppRoutes.paywall));
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: [
                AppLargeTitle(title: l10n.navSettings),
                const SizedBox(height: AppSpacing.lg),
                SectionCard(
                  onTap: editProfile,
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      BusinessLogo(
                        businessName: businessName,
                        logoPath: profile?.logoPath,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessName,
                              style: AppTextStyles.planTitle.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            if ((profile?.email ?? '').isNotEmpty)
                              Text(
                                profile!.email!,
                                style: AppTextStyles.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      AppIconButton(
                        icon: AppIcon.pen,
                        semanticLabel: l10n.actionEdit,
                        onPressed: editProfile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.errorKind != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  InlineErrorText(
                    message: state.errorKind == SettingsError.link
                        ? l10n.errorOpenLink
                        : l10n.paywallUnavailable,
                  ),
                ],
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupBusiness,
                  children: [
                    AppListTile(
                      icon: AppIcon.briefcase,
                      title: l10n.settingsBusinessProfile,
                      onTap: editProfile,
                    ),
                    AppListTile(
                      icon: AppIcon.palette,
                      title: l10n.settingsPdfBranding,
                      onTap: editProfile,
                    ),
                    AppListTile(
                      icon: AppIcon.percent,
                      title: l10n.settingsQuoteDefaults,
                      trailingText: profile == null
                          ? null
                          : [
                              profile.currencyCode,
                              l10n.percentValue(
                                PercentFormatter.format(profile.taxRatePercent),
                              ),
                            ].join(l10n.separatorDot),
                      onTap: editDefaults,
                    ),
                    AppListTile(
                      icon: AppIcon.percent,
                      title: 'Pricing & invoice settings',
                      onTap: () => unawaited(
                        Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) => const BusinessDefaultsPage(),
                          ),
                        ),
                      ),
                    ),
                    AppListTile(
                      icon: AppIcon.hash,
                      title: l10n.settingsNumbering,
                      trailingText: profile == null
                          ? null
                          : l10n.numberingValue(
                              profile.quotePrefix,
                              profile.invoicePrefix,
                            ),
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
                  ],
                ),
                const SizedBox(height: AppSpacing.section),
                SettingsGroup(
                  title: l10n.settingsGroupSubscription,
                  children: [
                    AppListTile(
                      icon: AppIcon.crown,
                      title: 'Subscription',
                      onTap: openPaywall,
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
                      onTap: () {
                        if (cubit.hasPrivacyLink) {
                          unawaited(cubit.openPrivacy());
                        } else {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Privacy policy'),
                              content: const Text(
                                'The privacy policy is not available yet. Please try again later.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    AppListTile(
                      icon: AppIcon.file,
                      title: l10n.settingsTerms,
                      onTap: () {
                        if (cubit.hasTermsLink) {
                          unawaited(cubit.openTerms());
                        } else {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Terms & conditions'),
                              content: const Text(
                                'The terms and conditions are not available yet. Please try again later.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    if (cubit.hasSupportLink)
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
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About Price to Profit'),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'Price to Profit',
                        applicationVersion: state.version,
                        children: const [
                          Text(
                            'Quotes, invoices and profit tracking for hair extension professionals.',
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_outlined),
                      title: const Text('Delete account'),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Permanently delete account?'),
                            content: const Text(
                              'This deletes your account, business, library, quotes and invoices. This cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: const Text('Delete permanently'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed != true) return;
                        final deleted = await cubit.deleteAccount();
                        if (!context.mounted) return;
                        if (deleted) {
                          context.goNamed(AppRoutes.login);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Unable to delete your account. Please retry.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
                  state.version == null
                      ? l10n.appName
                      : l10n.settingsVersion(state.version!),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
