/// What the account screens need from the backend. Each call returns true on
/// success and false when the request was rejected; throwing is reserved for
/// unexpected errors, which the cubits turn into a generic failure message.
///
/// The screens are built against this seam so the real API can be connected
/// without touching any UI: implement it with the auth endpoints and register
/// it in the DI container in place of LocalAccountGateway.
abstract interface class AccountGateway {
  Future<bool> logIn({required String email, required String password});

  Future<bool> register({required String name, required String email, required String password});

  Future<bool> requestPasswordReset({required String email});
}
