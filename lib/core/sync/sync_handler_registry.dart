import 'package:hairextensions/core/sync/sync_handler.dart';
import 'package:injectable/injectable.dart';

/// Features register their handler at init, keeping core unaware of features.
@lazySingleton
class SyncHandlerRegistry {
  final Map<String, SyncHandler> _handlers = {};

  void register(SyncHandler handler) {
    _handlers[handler.entity] = handler;
  }

  SyncHandler? handlerFor(String entity) => _handlers[entity];
}
