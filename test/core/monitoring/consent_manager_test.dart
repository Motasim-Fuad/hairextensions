import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/monitoring/consent/consent_manager.dart';
import 'package:hairextensions/core/monitoring/consent/consent_settings.dart';

import '../../helpers/fakes/in_memory_key_value_store.dart';

void main() {
  test('collection is off until the user answers', () {
    final manager = ConsentManager(InMemoryKeyValueStore());
    expect(
      manager.current,
      const ConsentSettings(analyticsEnabled: false, crashReportingEnabled: false, hasAnswered: false),
    );
  });

  test('update persists and emits the new settings', () async {
    final manager = ConsentManager(InMemoryKeyValueStore());
    final emitted = expectLater(
      manager.changes,
      emits(const ConsentSettings(analyticsEnabled: false, crashReportingEnabled: true, hasAnswered: true)),
    );

    await manager.update(analytics: false, crashReporting: true);

    await emitted;
    expect(manager.current.crashReportingEnabled, isTrue);
    await manager.dispose();
  });
}
