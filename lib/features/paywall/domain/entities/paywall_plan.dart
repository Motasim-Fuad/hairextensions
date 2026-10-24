/// Plans shown on the paywall. Prices are the design's launch prices in minor
/// units until store products are wired; then they come from the store.
enum PaywallPlan {
  annual(priceMinor: 24999, months: 12),
  monthly(priceMinor: 2999, months: 1);

  const PaywallPlan({required this.priceMinor, required this.months});

  static const String currency = 'AED';
  static const int trialDays = 7;

  final int priceMinor;
  final int months;

  int get monthlyMinor => (priceMinor / months).round();
}
