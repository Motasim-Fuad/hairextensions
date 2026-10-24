import 'package:flutter/services.dart';
import 'package:hairextensions/core/media/image_permission_denied_exception.dart';
import 'package:hairextensions/core/media/image_source_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ImageSourcePicker)
class PlatformImageSourcePicker implements ImageSourcePicker {
  static const String _accessDeniedSuffix = 'access_denied';

  ImagePicker? _picker;

  @override
  Future<String?> pickFromGallery({required double maxDimension, required int imageQuality}) async {
    try {
      final file = await (_picker ??= ImagePicker()).pickImage(
        source: ImageSource.gallery,
        maxWidth: maxDimension,
        maxHeight: maxDimension,
        imageQuality: imageQuality,
        requestFullMetadata: false,
      );
      return file?.path;
    } on PlatformException catch (error) {
      if (error.code.endsWith(_accessDeniedSuffix)) {
        throw const ImagePermissionDeniedException();
      }
      rethrow;
    }
  }
}
