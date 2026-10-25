import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart';
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart';
import 'package:hairextensions/core/network/client/dio_base_options.dart';
import 'package:hairextensions/core/network/interceptors/auth_interceptor.dart';
import 'package:hairextensions/core/network/interceptors/logging_interceptor.dart';
import 'package:hairextensions/core/network/interceptors/performance_interceptor.dart';
import 'package:hairextensions/core/network/interceptors/retry_interceptor.dart';
import 'package:hairextensions/core/network/interceptors/session_expiry_interceptor.dart';
import 'package:hairextensions/core/network/security/certificate_pinning.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:injectable/injectable.dart';

/// Main client used by every remote datasource.
@lazySingleton
class DioFactory {
  DioFactory(
    this._config,
    this._tokenStore,
    this._expiryNotifier,
    this._tracer,
  );

  final AppConfig _config;
  final SecureTokenStore _tokenStore;
  final SessionExpiryNotifier _expiryNotifier;
  final PerformanceTracer _tracer;

  Dio create() {
    final dio = Dio(DioBaseOptions.from(_config));
    CertificatePinning.apply(dio, _config);
    dio.interceptors.addAll([
      AuthInterceptor(_tokenStore),
      SessionExpiryInterceptor(tokenStore: _tokenStore, expiryNotifier: _expiryNotifier),
      RetryInterceptor(dio: dio),
      PerformanceInterceptor(_tracer),
      if (kDebugMode) LoggingInterceptor(),
    ]);
    return dio;
  }
}
