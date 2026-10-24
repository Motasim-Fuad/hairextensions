import 'package:hairextensions/core/session/app_session.dart';

class FakeAppSession implements AppSession {
  FakeAppSession({this.onboardingSeen = false, this.setupCompleted = false});

  @override
  bool onboardingSeen;

  @override
  bool setupCompleted;

  @override
  Future<void> markOnboardingSeen() async => onboardingSeen = true;

  @override
  Future<void> markSetupCompleted() async => setupCompleted = true;
}
