enum DepositType {
  percent,
  fixed;

  static DepositType fromName(String? value) {
    return DepositType.values.firstWhere((type) => type.name == value, orElse: () => DepositType.percent);
  }
}
