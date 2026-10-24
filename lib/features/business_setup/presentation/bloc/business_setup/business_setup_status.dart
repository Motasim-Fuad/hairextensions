enum BusinessSetupStatus {
  loading,
  loadFailure,
  editing,
  saving,

  /// First-launch setup finished; navigate to the all-set screen.
  completed,

  /// An edit flow saved; close the screen.
  saved;

  bool get isDone => this == completed || this == saved;
}
