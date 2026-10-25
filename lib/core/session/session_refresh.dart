import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Lets the router re-run its guards when the session ends (logout or an
/// expired token) without the user navigating. Sign-in deliberately does not
/// notify: the login screen navigates explicitly right after it succeeds.
@lazySingleton
class SessionRefresh extends ChangeNotifier {
  void signedOut() => notifyListeners();
}
