import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/router/deep_links/notification_route_resolver.dart';
import 'package:hairextensions/core/routing/app_routes.dart';

void main() {
  test('maps allow-listed route names to locations', () {
    expect(NotificationRouteResolver.locationFor({'route': AppRoutes.quotes}), AppRoutes.quotesPath);
    expect(NotificationRouteResolver.locationFor({'route': AppRoutes.newQuote}), AppRoutes.newQuotePath);
  });

  test('rejects unknown names, raw paths and missing values', () {
    expect(NotificationRouteResolver.locationFor({'route': '/settings/business-profile'}), isNull);
    expect(NotificationRouteResolver.locationFor({'route': 'admin'}), isNull);
    expect(NotificationRouteResolver.locationFor({'route': 3}), isNull);
    expect(NotificationRouteResolver.locationFor({}), isNull);
  });
}
