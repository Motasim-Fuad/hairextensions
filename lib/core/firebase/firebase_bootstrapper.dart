import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';

/// Initializes Firebase once, after the first frame. Reads the per-flavor
/// native config (google-services.json, GoogleService-Info.plist). When the
/// config is missing, every Firebase backed service stays a silent no-op.
@lazySingleton
class FirebaseBootstrapper {
  static const String _source = 'FirebaseBootstrapper';

  final Completer<bool> _ready = Completer<bool>();
  Future<bool>? _initializing;
  bool _isReady = false;

  bool get isReady => _isReady;

  Future<bool> get whenReady => _ready.future;

  Future<bool> initialize() => _initializing ??= _initialize();

  Future<bool> _initialize() async {
    try {
      await Firebase.initializeApp();
      _isReady = true;
      AppLogger.debug(_source, 'ready');
    } on Object catch (error) {
      AppLogger.warning(_source, 'unavailable $error');
    }
    _ready.complete(_isReady);
    return _isReady;
  }
}
