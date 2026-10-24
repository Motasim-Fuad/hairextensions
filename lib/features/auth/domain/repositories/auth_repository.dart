import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/auth/domain/entities/device_session.dart';

abstract interface class AuthRepository {
  /// Reuses stored tokens or registers the device. Safe to call repeatedly.
  Future<Either<Failure, DeviceSession>> ensureSession();

  Future<void> endSession();
}
