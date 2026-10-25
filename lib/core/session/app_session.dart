/// First-launch progress read synchronously by the router guards.
abstract interface class AppSession {
  bool get onboardingSeen;

  bool get setupCompleted;

  /// True once the stylist has logged in and until the session ends.
  bool get signedIn;

  Future<void> markOnboardingSeen();

  Future<void> markSetupCompleted();

  Future<void> markSignedIn();

  /// Ends the signed-in state and resets setup, so the next account decides
  /// for itself whether it still has to create a business.
  Future<void> markSignedOut();
}
