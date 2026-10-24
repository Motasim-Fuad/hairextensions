/// Load state for screens fed by a local stream: the first emission flips
/// loading to ready; local reads do not fail in a way the UI can recover from.
enum ViewStatus { loading, ready }
