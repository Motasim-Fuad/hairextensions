import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_scope.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';

/// Builds [child] only when [feature] is enabled, so a disabled feature never
/// constructs its widgets or blocs.
class FeatureGate extends StatelessWidget {
  const FeatureGate({required this.feature, required this.child, super.key, this.fallback});

  final FeatureKey feature;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (FeatureFlagScope.isEnabled(context, feature)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}
