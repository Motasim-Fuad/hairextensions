/// User properties used as segments in Analytics and as Remote Config
/// targeting conditions. Register each one in the Firebase console.
abstract final class AnalyticsUserProperties {
  static const String plan = 'plan';
  static const String betaCohort = 'beta_cohort';
  static const String appVersion = 'app_version';
  static const String businessCurrency = 'business_currency';
}
