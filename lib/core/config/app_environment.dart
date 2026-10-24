/// Selects which data source implementations DI wires up.
enum AppEnvironment {
  mock,
  dev,
  prod;

  static AppEnvironment fromName(String value) {
    return AppEnvironment.values.firstWhere(
      (environment) => environment.name == value,
      orElse: () => AppEnvironment.mock,
    );
  }

  bool get usesRemoteApi => this != AppEnvironment.mock;
}
