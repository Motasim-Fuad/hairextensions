import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_status.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_content.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_continue_bar.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_header.dart';
import 'package:hairextensions/features/business_setup/presentation/pages/business_setup/widgets/setup_pop_scope.dart';

/// Success is silent: finishing setup navigates to the all-set screen and an
/// edit flow simply closes.
class BusinessSetupView extends StatelessWidget {
  const BusinessSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BusinessSetupBloc, BusinessSetupState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.status.isDone,
      listener: (context, state) async {
        if (state.status == BusinessSetupStatus.completed) {
          await getIt<AuthRepository>().endSession();
          if (context.mounted) context.goNamed(AppRoutes.login);
        } else {
          context.pop();
        }
      },
      child: const SetupPopScope(
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SetupHeader(),
                Expanded(child: SetupContent()),
              ],
            ),
          ),
          bottomNavigationBar: SetupContinueBar(),
        ),
      ),
    );
  }
}
