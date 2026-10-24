import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hairextensions/core/connectivity/connectivity_service.dart';
import 'package:injectable/injectable.dart';

/// Listens to the platform only while someone is subscribed, so there is no
/// background listener when no screen or sync job needs it.
@LazySingleton(as: ConnectivityService)
class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService(this._connectivity) {
    _controller = StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
  }

  final Connectivity _connectivity;
  late final StreamController<bool> _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _lastKnownOnline = true;

  @override
  bool get lastKnownOnline => _lastKnownOnline;

  @override
  Stream<bool> get onStatusChange => _controller.stream.distinct();

  @override
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return _lastKnownOnline = _hasConnection(results);
  }

  void _startListening() {
    _subscription ??= _connectivity.onConnectivityChanged.listen((results) {
      _lastKnownOnline = _hasConnection(results);
      _controller.add(_lastKnownOnline);
    });
  }

  Future<void> _stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  static bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _stopListening();
    await _controller.close();
  }
}
