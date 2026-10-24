import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/logo_upload_placeholder.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_soft_button.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/media/business_logo.dart';

class LogoPickerTile extends StatelessWidget {
  const LogoPickerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      BusinessSetupBloc,
      BusinessSetupState,
      ({String? logoPath, String businessName, bool isPicking, Failure? failure})
    >(
      selector: (state) => (
        logoPath: state.draft.logoPath,
        businessName: state.draft.valueOf(SetupField.businessName),
        isPicking: state.isPickingLogo,
        failure: state.logoFailure,
      ),
      builder: (context, logo) {
        final l10n = context.l10n;
        final bloc = context.read<BusinessSetupBloc>();
        final path = logo.logoPath;
        final failure = logo.failure;
        void pick() => bloc.add(const BusinessSetupLogoPickRequested());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (path == null)
                  LogoUploadPlaceholder(onTap: logo.isPicking ? null : pick)
                else
                  BusinessLogo(businessName: logo.businessName, logoPath: path, size: AppSizes.logoLarge),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.setupLogoTitle, style: context.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.setupLogoHint,
                        style: context.textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppSoftButton(
                            label: path == null ? l10n.setupChooseImage : l10n.setupChangeImage,
                            onPressed: pick,
                            isLoading: logo.isPicking,
                            isCompact: true,
                          ),
                          if (path != null)
                            AppLinkButton(
                              label: l10n.setupRemoveImage,
                              onPressed: () => bloc.add(const BusinessSetupLogoRemoved()),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.sm),
              InlineErrorText(
                message: failure.localizedMessage(l10n),
                actionLabel: failure is PermissionDeniedFailure ? l10n.actionOpenSettings : null,
                onAction: failure is PermissionDeniedFailure
                    ? () => bloc.add(const BusinessSetupSettingsRequested())
                    : null,
              ),
            ],
          ],
        );
      },
    );
  }
}
