import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';

class SetupLoadError extends StatelessWidget {
  const SetupLoadError({required this.failure, super.key});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: InlineErrorText(
          message: failure.localizedMessage(l10n),
          actionLabel: l10n.actionRetry,
          onAction: () {
            final bloc = context.read<BusinessSetupBloc>();
            bloc.add(BusinessSetupStarted(bloc.state.flow));
          },
        ),
      ),
    );
  }
}
