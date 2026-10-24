import 'package:flutter/widgets.dart';

/// Checks Pro access before a Pro-only action. When access is missing it
/// shows the lock sheet and returns false, so callers simply skip the action.
abstract interface class ProGate {
  Future<bool> ensurePro(BuildContext context);
}
