import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRemoteDataSource, env: DiEnv.mockOnly)
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  AuthRemoteDataSourceMock(this._ids);

  static const int _expiresInSeconds = 3600;
  static const String _accessPrefix = 'mock-access-';
  static const String _refreshPrefix = 'mock-refresh-';

  final IdGenerator _ids;

  @override
  Future<ApiResponse<AuthTokensModel>> registerDevice({required String deviceId, required String platform}) {
    return _issue();
  }

  @override
  Future<ApiResponse<AuthTokensModel>> refresh(String refreshToken) => _issue();

  Future<ApiResponse<AuthTokensModel>> _issue() async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    final id = _ids.next();
    return ApiResponse.success(
      AuthTokensModel(
        accessToken: '$_accessPrefix$id',
        refreshToken: '$_refreshPrefix$id',
        expiresInSeconds: _expiresInSeconds,
      ),
    );
  }
}
