import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/auth/domain/entities/device_session.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EnsureDeviceSession {
  EnsureDeviceSession(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, DeviceSession>> call() => _repository.ensureSession();
}
