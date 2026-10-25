import 'package:hairextensions/core/constants/network_constants.dart';

abstract final class BusinessProfileEndpoints {
  /// GET, PATCH of the signed-in account's business.
  static const String profile = '${NetworkConstants.apiPrefix}/business';

  /// POST that creates the first business of an account.
  static const String create = '${NetworkConstants.apiPrefix}/businesses';
}
