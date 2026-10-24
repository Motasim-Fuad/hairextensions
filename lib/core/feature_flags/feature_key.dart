/// Every remotely switchable feature. [defaultEnabled] ships in the binary and
/// applies until Remote Config answers, including the very first launch.
enum FeatureKey {
  quoteBuilder('feature_quote_builder', 'quote_builder', defaultEnabled: true),
  invoices('feature_invoices', 'invoices', defaultEnabled: true),
  pdfExport('feature_pdf_export', 'pdf_export', defaultEnabled: true),
  internalCostSheet('feature_internal_cost_sheet', 'internal_cost_sheet', defaultEnabled: true),
  profitInsights('feature_profit_insights', 'profit_insights', defaultEnabled: true),
  library('feature_library', 'library', defaultEnabled: true),
  subscriptions('feature_subscriptions', 'subscriptions', defaultEnabled: true),
  quoteDuplicate('feature_quote_duplicate', 'quote_duplicate', defaultEnabled: true),
  cloudSync('feature_cloud_sync', 'cloud_sync', defaultEnabled: false),
  pushNotifications('feature_push_notifications', 'push_notifications', defaultEnabled: false);

  const FeatureKey(this.remoteKey, this.analyticsName, {required this.defaultEnabled});

  final String remoteKey;
  final String analyticsName;
  final bool defaultEnabled;
}
