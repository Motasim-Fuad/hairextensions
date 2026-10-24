import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';

/// Exposes flags to the tree. Only widgets that call [isEnabled] depend on
/// it and rebuild when remote values change.
class FeatureFlagScope extends InheritedNotifier<FeatureFlagService> {
  const FeatureFlagScope({required FeatureFlagService service, required super.child, super.key})
    : super(notifier: service);

  static bool isEnabled(BuildContext context, FeatureKey key) {
    final scope = context.dependOnInheritedWidgetOfExactType<FeatureFlagScope>();
    return scope?.notifier?.isEnabled(key) ?? key.defaultEnabled;
  }

  static FeatureFlagService? read(BuildContext context) {
    return context.getInheritedWidgetOfExactType<FeatureFlagScope>()?.notifier;
  }
}
