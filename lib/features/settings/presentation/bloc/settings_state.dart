part of 'settings_cubit.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.profile,
    this.productCount = 0,
    this.materialCount = 0,
    this.serviceCount = 0,
    this.isPro = false,
    this.version,
    this.errorKind,
  });

  final BusinessProfile? profile;
  final int productCount;
  final int materialCount;
  final int serviceCount;
  final bool isPro;
  final String? version;
  final SettingsError? errorKind;

  SettingsState copyWith({
    BusinessProfile? profile,
    int? productCount,
    int? materialCount,
    int? serviceCount,
    bool? isPro,
    String? version,
    SettingsError? errorKind,
    bool clearError = false,
  }) {
    return SettingsState(
      profile: profile ?? this.profile,
      productCount: productCount ?? this.productCount,
      materialCount: materialCount ?? this.materialCount,
      serviceCount: serviceCount ?? this.serviceCount,
      isPro: isPro ?? this.isPro,
      version: version ?? this.version,
      errorKind: clearError ? null : errorKind ?? this.errorKind,
    );
  }

  @override
  List<Object?> get props => [profile, productCount, materialCount, serviceCount, isPro, version, errorKind];
}
