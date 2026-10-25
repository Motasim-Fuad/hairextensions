import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:injectable/injectable.dart';

/// Account screens backed by the real auth endpoints.
@LazySingleton(as: AccountGateway)
class ApiAccountGateway implements AccountGateway {
  ApiAccountGateway(this._repository);

  final AuthRepository _repository;

  @override
  Future<bool> logIn({required String email, required String password}) async {
    final result = await _repository.login(email: email, password: password);
    return result.isRight();
  }

  @override
  Future<bool> register({required String name, required String email, required String password}) async {
    final result = await _repository.register(name: name, email: email, password: password);
    return result.isRight();
  }

  @override
  Future<bool> verifyOtp({required String email, required String otp}) async {
    final result = await _repository.verifyOtp(email: email, otp: otp);
    return result.isRight();
  }

  @override
  Future<bool> resendOtp({required String email}) async {
    final result = await _repository.resendOtp(email: email);
    return result.isRight();
  }

  @override
  String? takePendingOtp(String email) => _repository.takePendingOtp(email);

  /// The API has no password-reset endpoint yet, so this always reports
  /// failure rather than pretending an email was sent.
  @override
  Future<bool> requestPasswordReset({required String email}) async => false;
}
