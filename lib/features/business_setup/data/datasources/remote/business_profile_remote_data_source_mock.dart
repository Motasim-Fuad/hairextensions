import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';
import 'package:injectable/injectable.dart';

/// In-memory server with realistic latency, so the sync path runs end to end
/// without a backend.
@LazySingleton(as: BusinessProfileRemoteDataSource, env: DiEnv.mockOnly)
class BusinessProfileRemoteDataSourceMock implements BusinessProfileRemoteDataSource {
  Map<String, Object?>? _stored;

  @override
  Future<ApiResponse<BusinessProfileModel?>> fetch() async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    final stored = _stored;
    return ApiResponse.success(stored == null ? null : BusinessProfileModel.fromJson(stored));
  }

  @override
  Future<ApiResponse<void>> push(Map<String, Object?> payload) async {
    await Future<void>.delayed(NetworkConstants.mockLatency);
    _stored = Map.of(payload);
    return ApiResponse<void>.success(null);
  }
}
