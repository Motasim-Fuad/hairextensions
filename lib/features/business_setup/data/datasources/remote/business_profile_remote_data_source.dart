import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';

abstract interface class BusinessProfileRemoteDataSource {
  /// Data is null when the server has no profile for this device yet.
  Future<ApiResponse<BusinessProfileModel?>> fetch();

  Future<ApiResponse<void>> push(Map<String, Object?> payload);
}
