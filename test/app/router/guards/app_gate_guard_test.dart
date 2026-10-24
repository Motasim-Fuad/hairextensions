import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/guards/app_gate_guard.dart';
import 'package:hairextensions/core/feature_flags/app_gate_status.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks/mock_app_gate_service.dart';

void main() {
  late MockAppGateService gate;
  late AppGateGuard guard;

  setUp(() {
    gate = MockAppGateService();
    guard = AppGateGuard(gate);
  });

  String? redirect(String path) => guard.redirect(Uri.parse(path));

  test('maintenance overrides every route and holds the user there', () {
    when(() => gate.status).thenReturn(AppGateStatus.maintenance);
    expect(redirect(AppRoutes.quotesPath), AppRoutes.maintenancePath);
    expect(redirect(AppRoutes.maintenancePath), AppRoutes.maintenancePath);
  });

  test('a required update blocks the app', () {
    when(() => gate.status).thenReturn(AppGateStatus.updateRequired);
    expect(redirect(AppRoutes.homePath), AppRoutes.forceUpdatePath);
    expect(redirect(AppRoutes.forceUpdatePath), AppRoutes.forceUpdatePath);
  });

  test('a recommended update does not block', () {
    when(() => gate.status).thenReturn(AppGateStatus.updateRecommended);
    expect(redirect(AppRoutes.homePath), isNull);
  });

  test('leaves the blocking screens once the gate opens', () {
    when(() => gate.status).thenReturn(AppGateStatus.ok);
    expect(redirect(AppRoutes.maintenancePath), AppRoutes.homePath);
    expect(redirect(AppRoutes.forceUpdatePath), AppRoutes.homePath);
  });
}
