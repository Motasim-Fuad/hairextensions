import 'package:flutter/foundation.dart';
import 'package:hairextensions/app/background/background_task_scheduler.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/feature_module.dart';
import 'package:hairextensions/core/sync/sync_engine.dart';
import 'package:injectable/injectable.dart';

/// The sync engine and the periodic background task only run while cloud
/// sync is on. With it off, nothing listens, polls or wakes the device.
@lazySingleton
class CloudSyncModule implements FeatureModule {
  CloudSyncModule(this._engine, this._scheduler);

  final SyncEngine _engine;
  final BackgroundTaskScheduler _scheduler;

  @override
  FeatureKey get feature => FeatureKey.cloudSync;

  @override
  Future<void> initialize() async {
    _engine.start();
    if (_supportsBackgroundTasks) {
      await _scheduler.initialize();
    }
  }

  static bool get _supportsBackgroundTasks =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
}
