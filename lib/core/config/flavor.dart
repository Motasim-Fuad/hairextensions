enum Flavor {
  dev,
  staging,
  prod;

  static Flavor fromName(String value) {
    return Flavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => Flavor.dev,
    );
  }
}
