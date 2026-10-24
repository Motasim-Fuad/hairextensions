enum SyncQueueStatus {
  pending,
  inFlight,
  dead;

  static SyncQueueStatus fromName(String value) {
    return SyncQueueStatus.values.firstWhere((status) => status.name == value);
  }
}
