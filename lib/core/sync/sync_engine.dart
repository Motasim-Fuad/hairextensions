import 'dart:async';
import 'dart:math';

import 'package:hairextensions/core/connectivity/connectivity_service.dart';
import 'package:hairextensions/core/constants/sync_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/api_response/http_status_codes.dart';
import 'package:hairextensions/core/sync/sync_handler_registry.dart';
import 'package:hairextensions/core/sync/sync_operation.dart';
import 'package:hairextensions/core/sync/sync_queue.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:injectable/injectable.dart';

/// Drains the offline queue. Triggered by reconnect, new enqueues, a single
/// timer for the next scheduled retry, and the background task. No polling.
@lazySingleton
class SyncEngine {
  SyncEngine(this._queue, this._registry, this._connectivity, this._clock);

  static const String _source = 'SyncEngine';

  final SyncQueue _queue;
  final SyncHandlerRegistry _registry;
  final ConnectivityService _connectivity;
  final Clock _clock;
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<void>? _enqueueSubscription;
  Timer? _debounce;
  Timer? _retryTimer;
  Future<void>? _running;

  void start() {
    _connectivitySubscription ??= _connectivity.onStatusChange.where((isOnline) => isOnline).listen((_) => schedule());
    _enqueueSubscription ??= _queue.onEnqueued.listen((_) => schedule());
    schedule();
  }

  void schedule() {
    _debounce?.cancel();
    _debounce = Timer(SyncConstants.debounce, () => unawaited(runOnce()));
  }

  Future<void> runOnce() => _running ??= _drain().whenComplete(() => _running = null);

  Future<void> _drain() async {
    if (!await _connectivity.isOnline()) {
      return;
    }
    await _queue.recoverInFlight();
    while (true) {
      final batch = await _queue.due(limit: SyncConstants.batchSize);
      if (batch.isEmpty) {
        break;
      }
      for (final operation in batch) {
        final delivered = await _push(operation);
        if (!delivered && !_connectivity.lastKnownOnline) {
          return;
        }
      }
    }
    await _scheduleNextRetry();
  }

  Future<bool> _push(SyncOperation operation) async {
    final handler = _registry.handlerFor(operation.entity);
    if (handler == null) {
      AppLogger.warning(_source, 'no handler for ${operation.entity}');
      await _queue.reschedule(
        operation.id,
        attempts: operation.attempts,
        nextAttemptAt: _clock.now().add(SyncConstants.maxBackoff),
        error: 'no handler',
      );
      return true;
    }
    await _queue.markInFlight(operation.id);
    final ApiResponse<void> response;
    try {
      response = await handler.push(operation);
    } on Object catch (error) {
      AppLogger.error(_source, 'handler threw for ${operation.entity}', error);
      await _queue.reschedule(
        operation.id,
        attempts: operation.attempts + 1,
        nextAttemptAt: _clock.now().add(_backoffFor(operation.attempts + 1)),
        error: error.toString(),
      );
      return false;
    }
    if (response.isSuccess) {
      await _queue.complete(operation.id);
      return true;
    }
    final error = response.message ?? response.errorType.name;
    final attempts = operation.attempts + 1;
    final isPermanent = !response.isTransient && response.statusCode != HttpStatusCodes.unauthorized;
    if (isPermanent || attempts >= SyncConstants.maxAttempts) {
      AppLogger.warning(
        _source,
        'abandoned ${operation.entity} ${operation.entityId} $error',
      );
      await _queue.abandon(operation.id, error);
      return true;
    }
    await _queue.reschedule(
      operation.id,
      attempts: attempts,
      nextAttemptAt: _clock.now().add(_backoffFor(attempts)),
      error: error,
    );
    return false;
  }

  Duration _backoffFor(int attempts) {
    final seconds = SyncConstants.baseBackoff.inSeconds * pow(2, attempts - 1).toInt();
    return Duration(seconds: min(seconds, SyncConstants.maxBackoff.inSeconds));
  }

  Future<void> _scheduleNextRetry() async {
    _retryTimer?.cancel();
    final next = await _queue.nextDueAt();
    if (next == null) {
      return;
    }
    final wait = next.difference(_clock.now());
    _retryTimer = Timer(wait.isNegative ? Duration.zero : wait, schedule);
  }

  @disposeMethod
  Future<void> dispose() async {
    _debounce?.cancel();
    _retryTimer?.cancel();
    await _connectivitySubscription?.cancel();
    await _enqueueSubscription?.cancel();
    _connectivitySubscription = null;
    _enqueueSubscription = null;
  }
}
