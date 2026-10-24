import 'package:hairextensions/app/background/cloud_sync_module.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/feature_module.dart';
import 'package:hairextensions/features/business_setup/business_setup_module.dart';

/// Every feature module in the app. Add a new feature's module to
/// [features]. Resolved after the first frame so none of their dependencies
/// are built during startup.
abstract final class AppFeatureModules {
  static List<FeatureModule> features() => [
    getIt<BusinessSetupModule>(),
  ];

  /// The background isolate uses [features] only: it drains the queue once
  /// and must not start listeners or schedule tasks.
  static List<FeatureModule> foreground() => [
    getIt<CloudSyncModule>(),
    ...features(),
  ];
}
