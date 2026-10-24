import 'package:hairextensions/app/background/background_task_runner.dart';
import 'package:workmanager/workmanager.dart';

/// Entry point the OS calls in a background isolate. Must stay top-level.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) => BackgroundTaskRunner.run(task),
  );
}
