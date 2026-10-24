/// Picks one image from the gallery. Returns null when the user cancels and
/// throws ImagePermissionDeniedException when photo access is blocked.
abstract interface class ImageSourcePicker {
  Future<String?> pickFromGallery({required double maxDimension, required int imageQuality});
}
