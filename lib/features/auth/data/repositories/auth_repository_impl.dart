import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/identity/device_id_provider.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/domain/entities/device_session.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokens, this._deviceIds, this._clock);

  static const String _source = 'AuthRepository';

  final AuthRemoteDataSource _remote;
  final SecureTokenStore _tokens;
  final DeviceIdProvider _deviceIds;
  final Clock _clock;
  Future<Either<Failure, DeviceSession>>? _ensuring;

  @override
  Future<Either<Failure, DeviceSession>> ensureSession() {
    return _ensuring ??= _ensureSession().whenComplete(() => _ensuring = null);
  }

  Future<Either<Failure, DeviceSession>> _ensureSession() async {
    final deviceId = await _deviceIds.obtain();
    if (await _tokens.read() != null) {
      return Right(DeviceSession(deviceId: deviceId, isAuthenticated: true));
    }
    final response = await _remote.registerDevice(deviceId: deviceId, platform: defaultTargetPlatform.name);
    final model = response.data;
    if (!response.isSuccess || model == null) {
      AppLogger.warning(_source, 'device registration failed ${response.statusCode}');
      return Left(ApiFailureMapper.toFailure(response));
    }
    await _tokens.save(model.toEntity(_clock.now()));
    return Right(DeviceSession(deviceId: deviceId, isAuthenticated: true));
  }

  @override
  Future<void> endSession() => _tokens.clear();
}
