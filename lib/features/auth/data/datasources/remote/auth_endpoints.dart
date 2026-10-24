import 'package:hairextensions/core/constants/network_constants.dart';

abstract final class AuthEndpoints {
  static const String registerDevice = '/auth/device';
  static const String refresh = NetworkConstants.refreshPath;
  static const String deviceIdKey = 'device_id';
  static const String platformKey = 'platform';
  static const String refreshTokenKey = 'refresh_token';
}
