import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/guards/auth_guard.dart';
import 'package:hairextensions/core/routing/app_routes.dart';

import '../../../helpers/fakes/fake_app_session.dart';

void main() {
  test('a signed-out user can only reach the account screens', () {
    final guard = AuthGuard(FakeAppSession(onboardingSeen: true));

    expect(guard.redirect(Uri.parse(AppRoutes.homePath)), AppRoutes.loginPath);
    expect(guard.redirect(Uri.parse(AppRoutes.libraryPath)), AppRoutes.loginPath);
    expect(guard.redirect(Uri.parse(AppRoutes.loginPath)), isNull);
    expect(guard.redirect(Uri.parse(AppRoutes.registerPath)), isNull);
    expect(guard.redirect(Uri.parse(AppRoutes.verifyOtpPath)), isNull);
    expect(guard.redirect(Uri.parse(AppRoutes.forgotPasswordPath)), isNull);
  });

  test('a signed-in user is moved off the account screens', () {
    final guard = AuthGuard(FakeAppSession(onboardingSeen: true, signedIn: true));

    expect(guard.redirect(Uri.parse(AppRoutes.loginPath)), AppRoutes.homePath);
    expect(guard.redirect(Uri.parse(AppRoutes.verifyOtpPath)), AppRoutes.homePath);
    expect(guard.redirect(Uri.parse(AppRoutes.homePath)), isNull);
  });
}
