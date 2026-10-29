import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/app/app.dart';
import 'package:hairextensions/app/bootstrap/deferred_initializer.dart';
import 'package:hairextensions/app/router/app_router.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/app_bloc_observer.dart';
import 'package:hairextensions/core/monitoring/errors/global_error_handler.dart';
import 'package:hairextensions/core/monitoring/performance/startup_timer.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';

const String _source = 'Bootstrap';

Future<void> bootstrap() async {
  StartupTimer.markProcessStart();

  WidgetsFlutterBinding.ensureInitialized();

  // Configure status bar appearance for Android and iOS.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  final config = AppConfig.fromEnvironment();

  configureDependencies(config.environment.name);

  getIt<GlobalErrorHandler>().install();

  Bloc.observer = getIt<AppBlocObserver>();

  await getIt<KeyValueStore>().warmUp();
  final tokens = await getIt<SecureTokenStore>().read();
  if (tokens == null && getIt<AppSession>().signedIn) {
    await getIt<AppSession>().markSignedOut();
  }

  AppLogger.debug(
    _source,
    'flavor ${config.flavor.name} env ${config.environment.name}',
  );

  runApp(
    App(
      router: getIt<AppRouter>().config,
      flags: getIt<FeatureFlagService>(),
      connectivity: getIt<ConnectivityCubit>(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    StartupTimer.markFirstFrame();
    getIt<DeferredInitializer>().run();
  });
}
