import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/network/client/dio_base_options.dart';
import 'package:hairextensions/core/network/interceptors/logging_interceptor.dart';
import 'package:hairextensions/core/network/security/certificate_pinning.dart';
import 'package:injectable/injectable.dart';

/// Client without auth or session interceptors, used for the public auth
/// calls (register, verify-otp, login) where a 401 means wrong credentials,
/// not an expired session.
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
