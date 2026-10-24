import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';

/// Placeholder used until the account API is connected: waits briefly like a
/// network call would, then accepts everything. It stores nothing and checks
/// no credentials.
class LocalAccountGateway implements AccountGateway {
  const LocalAccountGateway();

  static const Duration _latency = Duration(milliseconds: 700);

  @override
  Future<bool> logIn({required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    return true;
  }

  @override
  Future<bool> register({required String name, required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    return true;
  }

  @override
  Future<bool> requestPasswordReset({required String email}) async {
    await Future<void>.delayed(_latency);
    return true;
  }
}
