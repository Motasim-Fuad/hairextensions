import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {ThemeData? theme}) {
    return pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.light(),
        localizationsDelegates: AppLocales.delegates,
        supportedLocales: AppLocales.supported,
        home: Scaffold(body: widget),
      ),
    );
  }
}
