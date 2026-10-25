import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/models/register_pending_model.dart';
import 'package:injectable/injectable.dart';

/// Accepts everything. The OTP is always 123456 in the mock environment.
@LazySingleton(as: AuthRemoteDataSource, env: DiEnv.mockOnly)
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  AuthRemoteDataSourceMock(this._ids);

  static const String _accessPrefix = 'mock-access-';
  static const String _mockOtp = '123456';

  final IdGenerator _ids;

  @override
  Future<ApiResponse<RegisterPendingModel>> register({
    required String name,
    required String email,
    required String password,
  }) => _pending(email);

  @override
  Future<ApiResponse<RegisterPendingModel>> resendOtp({required String email}) => _pending(email);

  @override
  Future<ApiResponse<void>> verifyOtp({required String email, required String otp}) async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    return ApiResponse<void>.success(null);
  }

  @override
  Future<ApiResponse<AuthTokensModel>> login({required String email, required String password}) async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    return ApiResponse.success(AuthTokensModel(accessToken: '$_accessPrefix${_ids.next()}', userEmail: email));
  }

  Future<ApiResponse<RegisterPendingModel>> _pending(String email) async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    return ApiResponse.success(RegisterPendingModel(email: email, message: 'OTP sent', otp: _mockOtp));
  }
}
