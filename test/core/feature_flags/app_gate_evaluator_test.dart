import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/feature_flags/app_gate_evaluator.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/feature_flags/app_status_config.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';

void main() {
  AppStatusConfig config({bool maintenance = false, String min = '1.0.0', String latest = '1.0.0'}) {
    return AppStatusConfig(
      minSupportedVersion: AppVersion.tryParse(min)!,
      latestVersion: AppVersion.tryParse(latest)!,
      maintenanceEnabled: maintenance,
      maintenanceMessage: '',
      storeUrl: '',
    );
  }

  const current = AppVersion(1, 2, 0);

  test('maintenance wins over every version rule', () {
    final status = AppGateEvaluator.evaluate(
      config: config(maintenance: true, min: '9.0.0'),
      current: current,
    );
    expect(status, AppGateStatus.maintenance);
    expect(status.isBlocking, isTrue);
  });

  test('below minimum requires an update', () {
    final status = AppGateEvaluator.evaluate(
      config: config(min: '1.3.0', latest: '1.3.0'),
      current: current,
    );
    expect(status, AppGateStatus.updateRequired);
    expect(status.isBlocking, isTrue);
  });

  test('below latest only recommends an update', () {
    final status = AppGateEvaluator.evaluate(
      config: config(latest: '1.5.0'),
      current: current,
    );
    expect(status, AppGateStatus.updateRecommended);
    expect(status.isBlocking, isFalse);
  });

  test('up to date is ok', () {
    expect(
      AppGateEvaluator.evaluate(
        config: config(latest: '1.2.0'),
        current: current,
      ),
      AppGateStatus.ok,
    );
  });
}
