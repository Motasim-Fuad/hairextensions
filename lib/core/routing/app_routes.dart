/// Route names and paths. Lives in core so features can navigate by name
/// without importing the app layer or each other.
abstract final class AppRoutes {
  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  static const String login = 'login';
  static const String loginPath = '/login';

  static const String register = 'register';
  static const String registerPath = '/register';

  static const String verifyOtp = 'verify-otp';
  static const String verifyOtpPath = '/verify-otp';

  static const String forgotPassword = 'forgot-password';
  static const String forgotPasswordPath = '/forgot-password';

  static const String paywall = 'paywall';
  static const String paywallPath = '/paywall';

  static const String setup = 'setup';
  static const String setupPath = '/setup';

  static const String setupComplete = 'setup-complete';
  static const String setupCompletePath = '/setup/complete';

  static const String home = 'home';
  static const String homePath = '/home';

  static const String quotes = 'quotes';
  static const String quotesPath = '/quotes';

  static const String library = 'library';
  static const String libraryPath = '/library';

  static const String settings = 'settings';
  static const String settingsPath = '/settings';

  static const String newQuote = 'new-quote';
  static const String newQuotePath = '/quote/new';

  static const String quoteReview = 'quote-review';
  static const String quoteReviewPath = 'review';

  static const String quoteDetail = 'quote-detail';
  static const String quoteDetailPath = '/quote/:id';

  static const String quotePreview = 'quote-preview';
  static const String quotePreviewPath = 'preview';

  static const String productForm = 'product-form';
  static const String productFormPath = '/product';

  static const String idParam = 'id';

  static const String editBusinessProfile = 'edit-business-profile';
  static const String editBusinessProfilePath = 'business-profile';

  static const String editQuoteDefaults = 'edit-quote-defaults';
  static const String editQuoteDefaultsPath = 'quote-defaults';

  static const String maintenance = 'maintenance';
  static const String maintenancePath = '/maintenance';

  static const String forceUpdate = 'force-update';
  static const String forceUpdatePath = '/update';
}
