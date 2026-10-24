/// First-launch progress read synchronously by the router guards.
abstract interface class AppSession {
  bool get onboardingSeen;

  bool get setupCompleted;

  Future<void> markOnboardingSeen();

  Future<void> markSetupCompleted();
}
