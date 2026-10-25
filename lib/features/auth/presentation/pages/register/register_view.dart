import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/register/register_state.dart';
import 'package:hairextensions/features/auth/presentation/extensions/auth_field_error_message.dart';
import 'package:hairextensions/features/auth/presentation/pages/otp/otp_page.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_switch_row.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_terms_checkbox.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';

/// Create an account. A successful registration continues to the email code
/// screen; signing in and business setup follow once the code is confirmed.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<RegisterCubit>().submit(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        confirmPassword: _confirm.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<RegisterCubit>();
    return BlocConsumer<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>
          previous.status != AuthSubmitStatus.success && current.status == AuthSubmitStatus.success,
      listener: (context, _) => context.goNamed(
        AppRoutes.verifyOtp,
        extra: OtpArguments(email: _email.text.trim(), password: _password.text),
      ),
      builder: (context, state) {
        return AuthScaffold(
          title: l10n.authRegisterTitle,
          subtitle: l10n.authRegisterSubtitle,
          children: [
            AppTextField(
              label: l10n.authFieldFullName,
              hintText: l10n.authFieldFullNameHint,
              controller: _name,
              errorText: state.nameError?.message(l10n),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              onChanged: (_) => cubit.fieldEdited(RegisterField.name),
              onSubmitted: (_) => _emailFocus.requestFocus(),
            ),
            AppTextField(
              label: l10n.authFieldEmail,
              hintText: l10n.authFieldEmailHint,
              controller: _email,
              focusNode: _emailFocus,
              errorText: state.emailError?.message(l10n),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => cubit.fieldEdited(RegisterField.email),
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            AuthPasswordField(
              label: l10n.authFieldPassword,
              hintText: l10n.authFieldPasswordHint,
              controller: _password,
              focusNode: _passwordFocus,
              errorText: state.passwordError?.message(l10n),
              isVisible: state.passwordVisible,
              onToggleVisibility: cubit.togglePasswordVisibility,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (_) => cubit.fieldEdited(RegisterField.password),
              onSubmitted: (_) => _confirmFocus.requestFocus(),
            ),
            AuthPasswordField(
              label: l10n.authFieldConfirmPassword,
              hintText: l10n.authFieldConfirmPasswordHint,
              controller: _confirm,
              focusNode: _confirmFocus,
              errorText: state.confirmError?.message(l10n),
              isVisible: state.passwordVisible,
              onToggleVisibility: cubit.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (_) => cubit.fieldEdited(RegisterField.confirm),
              onSubmitted: (_) => _submit(),
            ),
            AuthTermsCheckbox(
              value: state.termsAccepted,
              errorText: state.termsError?.message(l10n),
              onChanged: (accepted) => cubit.setTermsAccepted(accepted: accepted),
            ),
            AppPrimaryButton(
              label: l10n.authActionRegister,
              onPressed: _submit,
              isLoading: state.isSubmitting,
              errorText: state.status == AuthSubmitStatus.failure ? l10n.authErrorSubmitFailed : null,
            ),
            AuthSwitchRow(
              prompt: l10n.authHaveAccountPrompt,
              actionLabel: l10n.authActionLogin,
              onPressed: () => context.goNamed(AppRoutes.login),
            ),
          ],
        );
      },
    );
  }
}
