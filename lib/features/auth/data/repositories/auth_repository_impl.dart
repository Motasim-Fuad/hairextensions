import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/contracts/account_restorer.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/core/session/session_refresh.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokens, this._session, this._restorer, this._refresh);

  static const String _source = 'AuthRepository';

  final AuthRemoteDataSource _remote;
  final SecureTokenStore _tokens;
  final AppSession _session;
  final AccountRestorer _restorer;
  final SessionRefresh _refresh;
  final Map<String, String> _pendingOtps = {};

  @override
  Future<Either<Failure, Unit>> register({required String name, required String email, required String password}) async {
    final response = await _remote.register(name: name, email: email, password: password);
    _rememberOtp(email, response.data?.otp);
    return _result(response);
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String email, required String otp}) async {
    final response = await _remote.verifyOtp(email: email, otp: otp);
    return _result(response);
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    final response = await _remote.resendOtp(email: email);
    _rememberOtp(email, response.data?.otp);
    return _result(response);
  }

  @override
  Future<Either<Failure, Unit>> login({required String email, required String password}) async {
    final response = await _remote.login(email: email, password: password);
    final model = response.data;
    if (!response.isSuccess || model == null) {
      AppLogger.warning(_source, 'login failed ${response.statusCode}');
      return Left(ApiFailureMapper.toFailure(response));
    }
    await _tokens.save(model.toEntity());
    final restored = await _restorer.restore();
    if (restored.isLeft()) {
      // Without knowing whether a business exists the app cannot route
      // correctly, so the sign-in is rolled back and can simply be retried.
      await _tokens.clear();
      return restored.map((_) => unit);
    }
    await _session.markSignedIn();
    return const Right(unit);
  }

  @override
  Future<void> endSession() async {
    await _tokens.clear();
    await _restorer.clearLocal();
    await _session.markSignedOut();
    _refresh.signedOut();
  }

  @override
  String? takePendingOtp(String email) => _pendingOtps.remove(email.trim().toLowerCase());

  void _rememberOtp(String email, String? otp) {
    if (otp != null && otp.isNotEmpty) {
      _pendingOtps[email.trim().toLowerCase()] = otp;
    }
  }

  Either<Failure, Unit> _result(ApiResponse<Object?> response) {
    if (response.isSuccess) {
      return const Right(unit);
    }
    AppLogger.warning(_source, 'request failed ${response.statusCode}');
    return Left(ApiFailureMapper.toFailure(response));
  }
}
