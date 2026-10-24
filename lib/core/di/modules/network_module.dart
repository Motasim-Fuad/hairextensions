import 'package:dio/dio.dart';
import 'package:hairextensions/core/di/di_names.dart';
import 'package:hairextensions/core/network/client/bare_dio_factory.dart';
import 'package:hairextensions/core/network/client/dio_factory.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(DioFactory factory) => factory.create();

  @lazySingleton
  @Named(DiNames.bareDio)
  Dio bareDio(BareDioFactory factory) => factory.create();
}
