import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/security/certificate_fingerprint.dart';

/// Pins the server's leaf certificate. Ship the current and the next
/// certificate's fingerprints together before rotating, otherwise installed
/// apps stop reaching the API until they update.
abstract final class CertificatePinning {
  static const String _source = 'CertificatePinning';

  static void apply(Dio dio, AppConfig config) {
    if (!config.enableCertificatePinning) {
      return;
    }
    final pins = config.certificateFingerprints;
    if (pins.isEmpty) {
      AppLogger.warning(_source, 'enabled without fingerprints, pinning skipped');
      return;
    }
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient()..badCertificateCallback = (_, _, _) => false,
      validateCertificate: (certificate, _, _) =>
          certificate != null && CertificateFingerprint.matches(certificate.der, pins),
    );
  }
}
