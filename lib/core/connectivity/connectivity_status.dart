enum ConnectivityStatus {
  unknown,
  online,
  offline;

  bool get isOffline => this == ConnectivityStatus.offline;
}
