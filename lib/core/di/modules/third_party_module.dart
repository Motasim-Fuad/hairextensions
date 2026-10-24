import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:uuid/uuid.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  AppConfig get appConfig => AppConfig.fromEnvironment();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  sqflite.DatabaseFactory get databaseFactory => sqflite.databaseFactory;

  @lazySingleton
  Uuid get uuid => const Uuid();
}
