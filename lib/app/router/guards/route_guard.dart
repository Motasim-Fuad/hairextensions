/// One redirect rule. Returns null to let the next guard decide, another path
/// to redirect, or the current path to stay there and skip the remaining
/// guards. Without that stop, two guards can bounce the user between their
/// own screens forever. Guards must be synchronous and side-effect free.
abstract interface class RouteGuard {
  String? redirect(Uri location);
}
