import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';

/// Offline stand-in kept for widget tests and the mock environment: waits
/// briefly like a network call would, then accepts everything.
class LocalAccountGateway implements AccountGateway {
  const LocalAccountGateway();

  static const Duration _latency = Duration(milliseconds: 700);

  @override
  Future<bool> logIn({required String email, required String password}) => _accept();

  @override
  Future<bool> register({required String name, required String email, required String password}) => _accept();

  @override
  Future<bool> verifyOtp({required String email, required String otp}) => _accept();

  @override
  Future<bool> resendOtp({required String email}) => _accept();

  @override
  String? takePendingOtp(String email) => null;

  @override
  Future<bool> requestPasswordReset({required String email}) => _accept();

  Future<bool> _accept() async {
    await Future<void>.delayed(_latency);
    return true;
  }
}
