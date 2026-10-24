import 'package:hairextensions/core/feature_flags/feature_key.dart';

/// Optional startup work for a feature, such as registering sync handlers.
/// Runs only while the feature is enabled.
abstract interface class FeatureModule {
  FeatureKey get feature;

  Future<void> initialize();
}
