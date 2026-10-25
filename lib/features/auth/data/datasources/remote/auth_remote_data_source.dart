import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/models/register_pending_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApiResponse<RegisterPendingModel>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResponse<void>> verifyOtp({required String email, required String otp});

  Future<ApiResponse<RegisterPendingModel>> resendOtp({required String email});

  Future<ApiResponse<AuthTokensModel>> login({required String email, required String password});
}
