import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart';
import 'package:injectable/injectable.dart';

/// Lifecycle logs are debug only. Bloc errors are always forwarded to the
/// crash reporter as non-fatals.
@lazySingleton
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._crashReporter);

  static const int _maxStateLogLength = 160;

  final CrashReporter _crashReporter;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      AppLogger.debug('${bloc.runtimeType}', 'created');
    }
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      AppLogger.debug('${bloc.runtimeType}', '${event.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      final next = '${change.nextState}';
      final trimmed = next.length > _maxStateLogLength ? next.substring(0, _maxStateLogLength) : next;
      AppLogger.debug('${bloc.runtimeType}', trimmed);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error('${bloc.runtimeType}', 'unhandled error', error);
    unawaited(_crashReporter.recordError(error, stackTrace, reason: '${bloc.runtimeType}'));
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      AppLogger.debug('${bloc.runtimeType}', 'closed');
    }
  }
}
