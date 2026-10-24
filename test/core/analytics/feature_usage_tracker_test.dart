import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/analytics/analytics_event.dart';
import 'package:hairextensions/core/analytics/analytics_event_names.dart';
import 'package:hairextensions/core/analytics/analytics_params.dart';
import 'package:hairextensions/core/analytics/feature_usage_tracker.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks/mock_analytics_service.dart';

void main() {
  late MockAnalyticsService analytics;
  late FeatureUsageTracker tracker;

  setUpAll(() => registerFallbackValue(AnalyticsEvent('fallback')));

  setUp(() {
    analytics = MockAnalyticsService();
    when(() => analytics.logEvent(any())).thenAnswer((_) async {});
    tracker = FeatureUsageTracker(analytics);
  });

  AnalyticsEvent lastEvent() => verify(() => analytics.logEvent(captureAny())).captured.last as AnalyticsEvent;

  test('opened logs the feature and optional source', () {
    tracker.opened(FeatureKey.pdfExport, source: 'review');
    final event = lastEvent();
    expect(event.name, AnalyticsEventNames.featureOpened);
    expect(event.parameters, {
      AnalyticsParams.feature: FeatureKey.pdfExport.analyticsName,
      AnalyticsParams.source: 'review',
    });
  });

  test('used logs the action', () {
    tracker.used(FeatureKey.invoices, 'mark_paid');
    expect(lastEvent().parameters[AnalyticsParams.action], 'mark_paid');
  });

  test('session logs duration once even if ended twice', () {
    tracker.startSession(FeatureKey.quoteBuilder)
      ..end()
      ..end();
    final captured = verify(() => analytics.logEvent(captureAny())).captured;
    expect(captured, hasLength(1));
    final event = captured.single as AnalyticsEvent;
    expect(event.name, AnalyticsEventNames.featureSession);
    expect(event.parameters[AnalyticsParams.durationMs], isA<int>());
  });

  test('rejects invalid event names in debug', () {
    expect(() => AnalyticsEvent('Invalid-Name'), throwsAssertionError);
  });
}
