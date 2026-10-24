import 'package:hairextensions/app/background/callback_dispatcher.dart';
import 'package:hairextensions/core/constants/sync_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:workmanager/workmanager.dart';

/// Registers one long-interval sync task that only runs when the device is
/// online and the battery is not low. Called after the first frame.
@lazySingleton
class BackgroundTaskScheduler {
  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      SyncConstants.periodicTaskUniqueName,
      SyncConstants.periodicTaskName,
      frequency: SyncConstants.periodicFrequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  Future<void> cancelAll() => Workmanager().cancelAll();
}
