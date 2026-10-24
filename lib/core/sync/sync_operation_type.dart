enum SyncOperationType {
  create,
  update,
  delete;

  static SyncOperationType fromName(String value) {
    return SyncOperationType.values.firstWhere((type) => type.name == value);
  }
}
