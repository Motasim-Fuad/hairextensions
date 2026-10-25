/// Matches the API `RegisterPendingRead`. `otp` is only filled by the `local`
/// backend environment, where no email is sent.
class RegisterPendingModel {
  const RegisterPendingModel({required this.email, required this.message, this.otp});

  factory RegisterPendingModel.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    return RegisterPendingModel(
      email: map['email'] as String,
      message: map['message'] as String? ?? '',
      otp: map['otp'] as String?,
    );
  }

  final String email;
  final String message;
  final String? otp;
}
