/// Non-feature Remote Config parameters and custom signal names. Parameter
/// names must match the Firebase console exactly.
abstract final class RemoteConfigKeys {
  static const String minSupportedVersion = 'min_supported_version';
  static const String latestVersion = 'latest_version';
  static const String maintenanceMode = 'maintenance_mode';
  static const String maintenanceMessage = 'maintenance_message';
  static const String storeUrlAndroid = 'store_url_android';
  static const String storeUrlIos = 'store_url_ios';
  static const String termsUrl = 'terms_url';
  static const String privacyUrl = 'privacy_url';
  static const String supportEmail = 'support_email';
  static const String supportWhatsapp = 'support_whatsapp';

  static const String signalUserId = 'user_id';
  static const String signalBetaCohort = 'beta_cohort';
  static const String signalAppVersion = 'app_version';
}
