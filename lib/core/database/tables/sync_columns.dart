/// Columns every syncable table carries. Rows are soft-deleted so the delete
/// can be pushed to the server before the row is purged.
abstract final class SyncColumns {
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String deletedAt = 'deleted_at';
  static const String syncStatus = 'sync_status';
  static const String definition =
      "$createdAt INTEGER NOT NULL, $updatedAt INTEGER NOT NULL, $deletedAt INTEGER, $syncStatus TEXT NOT NULL DEFAULT 'pending'";
}
