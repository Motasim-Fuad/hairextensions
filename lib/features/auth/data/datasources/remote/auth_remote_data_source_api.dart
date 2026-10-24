import 'package:dio/dio.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/di/di_names.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_endpoints.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:injectable/injectable.dart';

/// Uses the bare client: neither call carries a bearer token, and a failing
/// refresh must never trigger another refresh.
@LazySingleton(as: AuthRemoteDataSource, env: DiEnv.remote)
class AuthRemoteDataSourceApi implements AuthRemoteDataSource {
  AuthRemoteDataSourceApi(@Named(DiNames.bareDio) Dio dio) : _client = ApiClient(dio);

  final ApiClient _client;

  @override
  Future<ApiResponse<AuthTokensModel>> registerDevice({required String deviceId, required String platform}) {
    return _client.post(
      AuthEndpoints.registerDevice,
      body: {AuthEndpoints.deviceIdKey: deviceId, AuthEndpoints.platformKey: platform},
      parser: AuthTokensModel.fromJson,
    );
  }

  @override
  Future<ApiResponse<AuthTokensModel>> refresh(String refreshToken) {
    return _client.post(
      AuthEndpoints.refresh,
      body: {AuthEndpoints.refreshTokenKey: refreshToken},
      parser: AuthTokensModel.fromJson,
    );
  }
}
