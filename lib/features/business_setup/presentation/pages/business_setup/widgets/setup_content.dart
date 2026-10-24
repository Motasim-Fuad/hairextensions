import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_status.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_load_error.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_skeleton.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_step_body.dart';
import 'package:hairextensions/shared/widgets/animations/fade_slide_switcher.dart';

class SetupContent extends StatelessWidget {
  const SetupContent({super.key});

  static const ValueKey<String> _loadingKey = ValueKey('loading');
  static const ValueKey<String> _errorKey = ValueKey('error');
  static const ValueKey<String> _formKey = ValueKey('form');

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, ({bool isLoading, Failure? loadFailure})>(
      selector: (state) => (
        isLoading: state.status == BusinessSetupStatus.loading,
        loadFailure: state.status == BusinessSetupStatus.loadFailure ? state.loadFailure : null,
      ),
      builder: (context, content) {
        final failure = content.loadFailure;
        return FadeSlideSwitcher(
          child: content.isLoading
              ? const SetupSkeleton(key: _loadingKey)
              : failure != null
              ? SetupLoadError(key: _errorKey, failure: failure)
              : const SetupStepBody(key: _formKey),
        );
      },
    );
  }
}
