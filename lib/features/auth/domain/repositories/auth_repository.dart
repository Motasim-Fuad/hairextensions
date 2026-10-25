import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';

abstract interface class AuthRepository {
  /// Creates the account. The API then sends a one-time code by email.
  Future<Either<Failure, Unit>> register({required String name, required String email, required String password});

  Future<Either<Failure, Unit>> verifyOtp({required String email, required String otp});

  Future<Either<Failure, Unit>> resendOtp({required String email});

  /// Signs in, stores the bearer token and restores the account's business.
  Future<Either<Failure, Unit>> login({required String email, required String password});

  /// The code the server returned with register/resend, which only the `local`
  /// backend does (no e-mail is sent there). Null otherwise; read once.
  String? takePendingOtp(String email);

  Future<void> endSession();
}
