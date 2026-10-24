import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_scope.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/localization/app_locales.dart';
import 'package:hairextensions/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    required this.router,
    required this.flags,
    required this.connectivity,
    super.key,
  });

  final GoRouter router;
  final FeatureFlagService flags;
  final ConnectivityCubit connectivity;

  static final ThemeData _light = AppTheme.light();
  static final ThemeData _dark = AppTheme.dark();

  static const SystemUiOverlayStyle _statusBarStyle =
  SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: FeatureFlagScope(
        service: flags,
        child: BlocProvider<ConnectivityCubit>.value(
          value: connectivity,
          child: MaterialApp.router(
            routerConfig: router,
            onGenerateTitle: (context) => context.l10n.appName,
            theme: _light,
            darkTheme: _dark,
            themeMode: ThemeMode.light,
            localizationsDelegates: AppLocales.delegates,
            supportedLocales: AppLocales.supported,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}