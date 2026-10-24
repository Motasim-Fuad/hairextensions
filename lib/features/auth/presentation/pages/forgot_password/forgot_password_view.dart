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
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:hairextensions/features/auth/presentation/extensions/auth_field_error_message.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Asks for the account email, then swaps the form for a confirmation. The
/// confirmation never says whether the account exists.
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    unawaited(context.read<ForgotPasswordCubit>().submit(email: _email.text));
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ForgotPasswordCubit>();
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        if (state.isSent) {
          return AuthScaffold(
            title: l10n.authForgotSentTitle,
            subtitle: l10n.authForgotSentBody,
            leading: const AppBackButton(),
            children: [
              const _SentBadge(),
              AppPrimaryButton(label: l10n.authActionBackToLogin, onPressed: _backToLogin),
            ],
          );
        }
        return AuthScaffold(
          title: l10n.authForgotTitle,
          subtitle: l10n.authForgotSubtitle,
          leading: const AppBackButton(),
          children: [
            AppTextField(
              label: l10n.authFieldEmail,
              hintText: l10n.authFieldEmailHint,
              controller: _email,
              errorText: state.emailError?.message(l10n),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => cubit.emailEdited(),
              onSubmitted: (_) => _submit(),
            ),
            AppPrimaryButton(
              label: l10n.authActionSendLink,
              onPressed: _submit,
              isLoading: state.isSubmitting,
              errorText: state.status == AuthSubmitStatus.failure ? l10n.authErrorSubmitFailed : null,
            ),
          ],
        );
      },
    );
  }
}

class _SentBadge extends StatelessWidget {
  const _SentBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.xxlAll),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: AppSvgIcon(AppIcon.mail, size: AppSizes.iconHero, color: colors.primary),
        ),
      ),
    );
  }
}
