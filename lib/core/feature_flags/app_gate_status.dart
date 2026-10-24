enum AppGateStatus {
  ok,
  updateRecommended,
  updateRequired,
  maintenance;

  /// Blocking states replace the whole app with a dedicated screen.
  bool get isBlocking => this == updateRequired || this == maintenance;
}
