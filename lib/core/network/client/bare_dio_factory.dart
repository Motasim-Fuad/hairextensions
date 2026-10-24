import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/network/client/dio_base_options.dart';
import 'package:hairextensions/core/network/interceptors/logging_interceptor.dart';
import 'package:hairextensions/core/network/security/certificate_pinning.dart';
import 'package:injectable/injectable.dart';

/// Client without auth or refresh interceptors, used for device registration
/// and the refresh call itself. Kept apart from DioFactory because the token
/// refresher depends on this client, and DioFactory depends on the refresher.
@lazySingleton
class BareDioFactory {
  BareDioFactory(this._config);

  final AppConfig _config;

  Dio create() {
    final dio = Dio(DioBaseOptions.from(_config));
    CertificatePinning.apply(dio, _config);
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }
    return dio;
  }
}
