/// Environment names used in injectable registrations. Swapping a mock for a
/// real implementation is done by the env list on one registration.
abstract final class DiEnv {
  static const String mock = 'mock';
  static const String dev = 'dev';
  static const String prod = 'prod';
  static const List<String> mockOnly = [mock];
  static const List<String> remote = [dev, prod];
}
