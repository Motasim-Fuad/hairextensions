enum AppPermissionStatus {
  granted,
  limited,
  denied,
  permanentlyDenied,
  restricted;

  bool get isUsable => this == AppPermissionStatus.granted || this == AppPermissionStatus.limited;

  /// Only the system settings screen can change these.
  bool get needsSettings => this == AppPermissionStatus.permanentlyDenied || this == AppPermissionStatus.restricted;
}
