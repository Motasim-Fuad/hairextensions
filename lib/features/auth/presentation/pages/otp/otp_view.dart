import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/auth/presentation/bloc/auth_submit_status.dart';
import 'package:hairextensions/features/auth/presentation/bloc/otp/otp_cubit.dart';
import 'package:hairextensions/features/auth/presentation/bloc/otp/otp_state.dart';
import 'package:hairextensions/features/auth/presentation/extensions/auth_field_error_message.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:hairextensions/features/auth/presentation/widgets/auth_switch_row.dart';
import 'package:hairextensions/shared/widgets/buttons/app_link_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';

/// Second step of registration: the one-time code sent to [email].
class OtpView extends StatefulWidget {
  const OtpView({required this.email, super.key, this.suggestedCode});

  final String email;
  final String? suggestedCode;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late final TextEditingController _code = TextEditingController(text: widget.suggestedCode);

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    unawaited(context.read<OtpCubit>().submit(_code.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<OtpCubit>();
    return BlocConsumer<OtpCubit, OtpState>(
      listenWhen: (previous, current) =>
          previous.status != AuthSubmitStatus.success && current.status == AuthSubmitStatus.success,
      // The account is signed in by now; the paywall comes next, then the
      // guards send the stylist on to business setup or home.
      listener: (context, _) => context.goNamed(AppRoutes.paywall),
      builder: (context, state) {
        return AuthScaffold(
          title: l10n.authOtpTitle,
          subtitle: '${l10n.authOtpSubtitle}\n${widget.email}',
          children: [
            AppTextField(
              label: l10n.authFieldOtp,
              hintText: l10n.authFieldOtpHint,
              controller: _code,
              errorText: state.codeError?.message(l10n),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofillHints: const [AutofillHints.oneTimeCode],
              autofocus: true,
              onChanged: (_) => cubit.codeEdited(),
              onSubmitted: (_) => _submit(),
            ),
            AppPrimaryButton(
              label: l10n.authActionVerify,
              onPressed: _submit,
              isLoading: state.isSubmitting,
              errorText: state.status == AuthSubmitStatus.failure ? l10n.authErrorOtpInvalid : null,
            ),
            Center(
              child: AppLinkButton(
                label: switch (state.resendStatus) {
                  OtpResendStatus.sent => l10n.authOtpResent,
                  OtpResendStatus.failure => l10n.authOtpResendFailed,
                  OtpResendStatus.idle || OtpResendStatus.sending => l10n.authActionResendOtp,
                },
                onPressed: state.isResending ? null : () => unawaited(cubit.resend()),
              ),
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
