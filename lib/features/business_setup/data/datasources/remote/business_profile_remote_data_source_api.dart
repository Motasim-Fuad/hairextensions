import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_endpoints.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BusinessProfileRemoteDataSource, env: DiEnv.remote)
class BusinessProfileRemoteDataSourceApi implements BusinessProfileRemoteDataSource {
  BusinessProfileRemoteDataSourceApi(this._client);

  final ApiClient _client;

  @override
  Future<ApiResponse<BusinessProfileModel?>> fetch() async {
    final response = await _client.get<BusinessProfileModel?>(
      BusinessProfileEndpoints.profile,
      parser: (json) => json == null ? null : BusinessProfileModel.fromJson(json),
    );
    return response.isNotFound ? ApiResponse.success(null, statusCode: response.statusCode) : response;
  }

  @override
  Future<ApiResponse<void>> push(Map<String, Object?> payload) {
    return _client.put<void>(BusinessProfileEndpoints.profile, body: payload, parser: (_) {});
  }
}
