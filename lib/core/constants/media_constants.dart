abstract final class MediaConstants {
  /// Logos print at most a few centimetres wide, so larger files only cost
  /// storage and PDF size.
  static const double logoMaxDimension = 1024;
  static const int logoImageQuality = 85;
  static const String logoDirectory = 'logos';
  static const String logoFilePrefix = 'logo_';
}
