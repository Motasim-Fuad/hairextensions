import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApiResponse<AuthTokensModel>> registerDevice({required String deviceId, required String platform});

  Future<ApiResponse<AuthTokensModel>> refresh(String refreshToken);
}
