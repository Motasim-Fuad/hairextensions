import 'package:hairextensions/core/constants/network_constants.dart';

abstract final class AuthEndpoints {
  static const String _base = '${NetworkConstants.apiPrefix}/auth';

  static const String register = '$_base/register';
  static const String verifyOtp = '$_base/verify-otp';
  static const String resendOtp = '$_base/resend-otp';
  static const String login = '$_base/login';

  static const String emailKey = 'email';
  static const String nameKey = 'name';
  static const String passwordKey = 'password';
  static const String otpKey = 'otp';
}
