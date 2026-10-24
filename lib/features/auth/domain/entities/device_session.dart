import 'package:equatable/equatable.dart';

/// Anonymous per-install session. Account login can later upgrade it without
/// changing callers.
class DeviceSession extends Equatable {
  const DeviceSession({required this.deviceId, required this.isAuthenticated});

  final String deviceId;
  final bool isAuthenticated;

  @override
  List<Object?> get props => [deviceId, isAuthenticated];
}
