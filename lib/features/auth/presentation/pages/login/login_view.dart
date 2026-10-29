import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/login/login_state.dart';
import 'package:hairextensions/features/auth/presentation/extensions/auth_field_error_message.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_switch_row.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';

/// Log in with email and password. A successful login continues the first
/// launch flow to the paywall.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<LoginCubit>().submit(
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<LoginCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != AuthSubmitStatus.success &&
          current.status == AuthSubmitStatus.success,
      listener: (context, _) => context.goNamed(AppRoutes.home),
      builder: (context, state) {
        return AuthScaffold(
          title: l10n.authLoginTitle,
          subtitle: l10n.authLoginSubtitle,
          children: [
            AppTextField(
              label: l10n.authFieldEmail,
              hintText: l10n.authFieldEmailHint,
              controller: _email,
              errorText: state.emailError?.message(l10n),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => cubit.emailEdited(),
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            AuthPasswordField(
              label: l10n.authFieldPassword,
              hintText: l10n.authFieldPassword,
              controller: _password,
              focusNode: _passwordFocus,
              errorText: state.passwordError?.message(l10n),
              isVisible: state.passwordVisible,
              onToggleVisibility: cubit.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: (_) => cubit.passwordEdited(),
              onSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppLinkButton(
                label: l10n.authForgotPasswordLink,
                onPressed: () => context.pushNamed(AppRoutes.forgotPassword),
              ),
            ),
            AppPrimaryButton(
              label: l10n.authActionLogin,
              onPressed: _submit,
              isLoading: state.isSubmitting,
              errorText: state.status == AuthSubmitStatus.failure
                  ? l10n.authErrorSubmitFailed
                  : null,
            ),
            AuthSwitchRow(
              prompt: l10n.authNoAccountPrompt,
              actionLabel: l10n.authActionRegister,
              onPressed: () => context.goNamed(AppRoutes.register),
            ),
          ],
        );
      },
    );
  }
}
