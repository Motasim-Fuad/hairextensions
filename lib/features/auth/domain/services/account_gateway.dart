/// What the account screens need from the backend. Each call returns true on
/// success and false when the request was rejected; throwing is reserved for
/// unexpected errors, which the cubits turn into a generic failure message.
abstract interface class AccountGateway {
  Future<bool> logIn({required String email, required String password});

  /// Creates the account. The next step is [verifyOtp] with the emailed code.
  Future<bool> register({required String name, required String email, required String password});

  Future<bool> verifyOtp({required String email, required String otp});

  Future<bool> resendOtp({required String email});

  /// Code returned by the server itself (local backend only); null otherwise.
  String? takePendingOtp(String email);

  Future<bool> requestPasswordReset({required String email});
}
