/// Opens links outside the app. Returns false when nothing could handle the
/// link, so callers can show an inline error.
abstract interface class LinkLauncher {
  Future<bool> open(String url);
}
