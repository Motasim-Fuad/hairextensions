import 'dart:async';

import 'package:hairextensions/core/analytics/analytics_service.dart';
import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:hairextensions/core/feature_flags/beta_targeting.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_module_registry.dart';
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart';
import 'package:hairextensions/core/monitoring/consent/consent_manager.dart';
import 'package:hairextensions/core/monitoring/consent/consent_settings.dart';
import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart';
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart';
import 'package:hairextensions/core/monitoring/performance/startup_timer.dart';
import 'package:hairextensions/core/monitoring/performance/trace_names.dart';
import 'package:injectable/injectable.dart';

/// Post-first-frame startup: Firebase, consent, flags, app gate and feature
/// modules. Nothing here blocks the first screen.
@lazySingleton
class MonitoringInitializer {
  MonitoringInitializer(
    this._firebase,
    this._consent,
    this._crashReporter,
    this._analytics,
    this._tracer,
    this._flags,
    this._gate,
    this._targeting,
    this._modules,
  );

  final FirebaseBootstrapper _firebase;
  final ConsentManager _consent;
  final CrashReporter _crashReporter;
  final AnalyticsService _analytics;
  final PerformanceTracer _tracer;
  final FeatureFlagService _flags;
  final AppGateService _gate;
  final BetaTargeting _targeting;
  final FeatureModuleRegistry _modules;
  StreamSubscription<ConsentSettings>? _consentSubscription;
  Future<void>? _running;

  Future<void> initialize() => _running ??= _initialize();

  /// Called when the app returns to the foreground. Remote Config throttles
  /// real network fetches by its minimum fetch interval.
  Future<void> onResume() => _flags.refresh();

  Future<void> _initialize() async {
    unawaited(_modules.initializeEnabled());
    await _gate.initialize();
    final ready = await _firebase.initialize();
    if (ready) {
      await _applyConsent(_consent.current);
      _consentSubscription ??= _consent.changes.listen((settings) => unawaited(_applyConsent(settings)));
      await _targeting.identify(appVersion: _gate.installedVersion ?? '');
      await _recordStartup();
    }
    await _flags.refresh();
  }

  Future<void> _applyConsent(ConsentSettings settings) async {
    await _crashReporter.setCollectionEnabled(enabled: settings.crashReportingEnabled);
    await _analytics.setCollectionEnabled(enabled: settings.analyticsEnabled);
    await _tracer.setCollectionEnabled(enabled: settings.analyticsEnabled);
  }

  Future<void> _recordStartup() async {
    final firstFrameMs = StartupTimer.firstFrameMs;
    if (firstFrameMs == null) {
      return;
    }
    final trace = await _tracer.startTrace(TraceNames.appStartup);
    trace.setMetric(TraceNames.firstFrameMetric, firstFrameMs);
    await trace.stop();
  }

  @disposeMethod
  Future<void> dispose() async => _consentSubscription?.cancel();
}
