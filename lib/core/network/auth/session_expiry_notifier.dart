import 'dart:async';

import 'package:injectable/injectable.dart';

/// Broadcasts when the session can no longer be refreshed so the auth layer
/// can reset state and the router can react.
@lazySingleton
class SessionExpiryNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onExpired => _controller.stream;

  void notifyExpired() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  @disposeMethod
  Future<void> dispose() => _controller.close();
}
