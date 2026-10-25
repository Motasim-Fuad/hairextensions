import 'package:dio/dio.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/di/di_names.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_endpoints.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/models/register_pending_model.dart';
import 'package:injectable/injectable.dart';

/// Uses the bare client: these calls are public and carry no bearer token, and
/// a 401 here means wrong credentials, not an expired session.
@LazySingleton(as: AuthRemoteDataSource, env: DiEnv.remote)
class AuthRemoteDataSourceApi implements AuthRemoteDataSource {
  AuthRemoteDataSourceApi(@Named(DiNames.bareDio) Dio dio) : _client = ApiClient(dio);

  final ApiClient _client;

  @override
  Future<ApiResponse<RegisterPendingModel>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _client.post(
      AuthEndpoints.register,
      body: {AuthEndpoints.nameKey: name, AuthEndpoints.emailKey: email, AuthEndpoints.passwordKey: password},
      parser: RegisterPendingModel.fromJson,
    );
  }

  @override
  Future<ApiResponse<void>> verifyOtp({required String email, required String otp}) {
    return _client.post<void>(
      AuthEndpoints.verifyOtp,
      body: {AuthEndpoints.emailKey: email, AuthEndpoints.otpKey: otp},
      parser: (_) {},
    );
  }

  @override
  Future<ApiResponse<RegisterPendingModel>> resendOtp({required String email}) {
    return _client.post(
      AuthEndpoints.resendOtp,
      body: {AuthEndpoints.emailKey: email},
      parser: RegisterPendingModel.fromJson,
    );
  }

  @override
  Future<ApiResponse<AuthTokensModel>> login({required String email, required String password}) {
    return _client.post(
      AuthEndpoints.login,
      body: {AuthEndpoints.emailKey: email, AuthEndpoints.passwordKey: password},
      parser: AuthTokensModel.fromJson,
    );
  }
}
