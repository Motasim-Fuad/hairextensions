import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:hairextensions/app/bootstrap/app_feature_modules.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/constants/sync_constants.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/feature_module_registry.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:hairextensions/core/sync/sync_engine.dart';

/// Runs inside the background isolate, which has its own fresh service
/// locator. Feature modules must be initialized here too, otherwise no sync
/// handler is registered and every queued operation is skipped.
abstract final class BackgroundTaskRunner {
  static const String _source = 'BackgroundTaskRunner';

  static Future<bool> run(String task) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    try {
      if (!getIt.isRegistered<SyncEngine>()) {
        await _prepare();
      }
      switch (task) {
        case SyncConstants.periodicTaskName:
          await getIt<SyncEngine>().runOnce();
      }
      return true;
    } on Object catch (error) {
      AppLogger.error(_source, 'task $task failed', error);
      return false;
    }
  }

  static Future<void> _prepare() async {
    configureDependencies(AppConfig.fromEnvironment().environment.name);
    await getIt<KeyValueStore>().warmUp();
    final registry = getIt<FeatureModuleRegistry>()..registerAll(AppFeatureModules.features());
    await registry.initializeEnabled();
  }
}
