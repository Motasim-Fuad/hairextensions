enum SubscriptionStatus {
  none,
  active,
  expired;

  static SubscriptionStatus fromName(String? value) {
    return SubscriptionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SubscriptionStatus.none,
    );
  }

  bool get isPro => this == SubscriptionStatus.active;
}
