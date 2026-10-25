import 'package:hairextensions/core/session/app_session.dart';

class FakeAppSession implements AppSession {
  FakeAppSession({this.onboardingSeen = false, this.setupCompleted = false, this.signedIn = false});

  @override
  bool onboardingSeen;

  @override
  bool setupCompleted;

  @override
  bool signedIn;

  @override
  Future<void> markOnboardingSeen() async => onboardingSeen = true;

  @override
  Future<void> markSetupCompleted() async => setupCompleted = true;

  @override
  Future<void> markSignedIn() async => signedIn = true;

  @override
  Future<void> markSignedOut() async {
    signedIn = false;
    setupCompleted = false;
  }
}
