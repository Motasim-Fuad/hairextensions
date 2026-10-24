import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';

/// System back moves to the previous step before leaving the screen. Only the
/// PopScope rebuilds on step changes; [child] is reused as is.
class SetupPopScope extends StatelessWidget {
  const SetupPopScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, bool>(
      selector: (state) => state.stepIndex == 0 && !state.isSaving,
      builder: (context, canLeave) {
        return PopScope(
          canPop: canLeave,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              context.read<BusinessSetupBloc>().add(const BusinessSetupBackPressed());
            }
          },
          child: child,
        );
      },
    );
  }
}
