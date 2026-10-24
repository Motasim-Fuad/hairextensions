import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/connectivity/connectivity_status.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/shared/widgets/feedback/offline_banner_content.dart';

/// Rebuilds only when the offline flag flips, never on other state changes.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConnectivityCubit, ConnectivityStatus, bool>(
      selector: (status) => status.isOffline,
      builder: (context, isOffline) {
        return AnimatedSize(
          duration: context.motion(AppMotion.medium),
          curve: AppMotion.standard,
          alignment: Alignment.topCenter,
          child: isOffline ? const OfflineBannerContent() : const SizedBox(width: double.infinity),
        );
      },
    );
  }
}
