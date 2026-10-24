abstract interface class LogoFileStore {
  /// Copies [sourcePath] into app storage and returns the stored path.
  Future<String> store(String sourcePath);

  Future<void> delete(String path);
}
