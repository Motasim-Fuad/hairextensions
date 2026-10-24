import 'package:hairextensions/core/config/app_environment.dart';
import 'package:hairextensions/core/config/flavor.dart';

/// Build-time configuration supplied through --dart-define. Holds no secrets.
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
        const String.fromEnvironment('ENV', defaultValue: 'mock'),
      ),
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.example.com',
      ),
      privacyPolicyUrl: const String.fromEnvironment(
        'PRIVACY_POLICY_URL',
        defaultValue: 'https://example.com/privacy',
      ),
      termsUrl: const String.fromEnvironment(
        'TERMS_URL',
        defaultValue: 'https://example.com/terms',
      ),
      supportEmail: const String.fromEnvironment(
        'SUPPORT_EMAIL',
        defaultValue: 'support@example.com',
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
