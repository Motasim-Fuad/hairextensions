import 'package:hairextensions/core/session/app_session.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';

/// Accepts every request and marks the session signed in on log in, like the
/// real gateway does, so route guards behave as they do in the app.
class SessionAccountGateway implements AccountGateway {
  SessionAccountGateway(this._session);

  final AppSession _session;

  @override
  Future<bool> logIn({required String email, required String password}) async {
    await _session.markSignedIn();
    return true;
  }

  @override
  Future<bool> register({required String name, required String email, required String password}) async => true;

  @override
  Future<bool> verifyOtp({required String email, required String otp}) async => true;

  @override
  Future<bool> resendOtp({required String email}) async => true;

  @override
  String? takePendingOtp(String email) => null;

  @override
  Future<bool> requestPasswordReset({required String email}) async => true;
}
