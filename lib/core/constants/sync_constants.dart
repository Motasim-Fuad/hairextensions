abstract final class SyncConstants {
  static const int batchSize = 25;
  static const int maxAttempts = 8;
  static const Duration baseBackoff = Duration(seconds: 30);
  static const Duration maxBackoff = Duration(hours: 6);
  static const Duration debounce = Duration(seconds: 2);
  static const String periodicTaskUniqueName = 'price_to_profit_periodic_sync';
  static const String periodicTaskName = 'periodicSync';
  static const Duration periodicFrequency = Duration(hours: 6);
}
