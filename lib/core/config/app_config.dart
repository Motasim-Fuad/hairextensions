import 'package:hairextensions/core/config/app_environment.dart';
import 'package:hairextensions/core/config/flavor.dart';

/// Build-time configuration supplied through --dart-define. Holds no secrets.
/// The legal and support values are optional fallbacks: the backend publishes
/// the real ones through GET /v1/app-config.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.environment,
    required this.apiBaseUrl,
    required this.privacyPolicyUrl,
    required this.termsUrl,
    required this.supportEmail,
    required this.enableCertificatePinning,
    required this.certificateFingerprints,
  });

  factory AppConfig.fromEnvironment() {
    const fingerprints = String.fromEnvironment('CERT_SHA256');
    return AppConfig(
      flavor: Flavor.fromName(
        const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
      ),
      environment: AppEnvironment.fromName(
        const String.fromEnvironment('ENV', defaultValue: 'dev'),
      ),
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://price-to-profit-alga-chul.onrender.com',
      ),
      privacyPolicyUrl: const String.fromEnvironment(
        'PRIVACY_POLICY_URL',
        defaultValue: '',
      ),
      termsUrl: const String.fromEnvironment(
        'TERMS_URL',
        defaultValue: '',
      ),
      supportEmail: const String.fromEnvironment(
        'SUPPORT_EMAIL',
        defaultValue: '',
      ),
      enableCertificatePinning: const bool.fromEnvironment(
        'ENABLE_CERT_PINNING',
      ),
      certificateFingerprints: fingerprints.split(',').where((value) => value.isNotEmpty).toList(),
    );
  }

  final Flavor flavor;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String privacyPolicyUrl;
  final String termsUrl;
  final String supportEmail;
  final bool enableCertificatePinning;
  final List<String> certificateFingerprints;

  bool get isProduction => flavor == Flavor.prod;
}
