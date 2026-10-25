import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_endpoints.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_api_mapper.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BusinessProfileRemoteDataSource, env: DiEnv.remote)
class BusinessProfileRemoteDataSourceApi implements BusinessProfileRemoteDataSource {
  BusinessProfileRemoteDataSourceApi(this._client);

  final ApiClient _client;

  /// A 404 means the account has no business yet, which is not an error.
  @override
  Future<ApiResponse<BusinessProfileModel?>> fetch() async {
    final response = await _client.get<BusinessProfileModel?>(
      BusinessProfileEndpoints.profile,
      parser: (json) => json == null ? null : BusinessProfileApiMapper.fromApi(json),
    );
    return response.isNotFound ? ApiResponse.success(null, statusCode: response.statusCode) : response;
  }

  /// Updates the business, creating it first when the account has none.
  @override
  Future<ApiResponse<void>> push(Map<String, Object?> payload) async {
    final body = BusinessProfileApiMapper.toApi(payload);
    final updated = await _client.patch<void>(BusinessProfileEndpoints.profile, body: body, parser: (_) {});
    if (!updated.isNotFound) {
      return updated;
    }
    return _client.post<void>(BusinessProfileEndpoints.create, body: body, parser: (_) {});
  }
}
