import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/connectivity/connectivity_service.dart';
import 'package:hairextensions/core/connectivity/connectivity_status.dart';
import 'package:injectable/injectable.dart';

/// App-wide connectivity state that drives the offline banner.
@lazySingleton
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit(this._service) : super(ConnectivityStatus.unknown);

  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  Future<void> start() async {
    if (_subscription != null) {
      return;
    }
    _subscription = _service.onStatusChange.listen(_update);
    _update(await _service.isOnline());
  }

  void _update(bool isOnline) {
    if (isClosed) {
      return;
    }
    emit(isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
