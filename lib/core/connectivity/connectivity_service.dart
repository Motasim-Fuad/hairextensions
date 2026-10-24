abstract interface class ConnectivityService {
  bool get lastKnownOnline;

  Stream<bool> get onStatusChange;

  Future<bool> isOnline();

  Future<void> dispose();
}
