import 'dart:io';

import 'package:hairextensions/core/constants/media_constants.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Picker output lives in a temp directory the OS may clear, so the logo is
/// copied into application support. A new file name per pick busts the
/// image cache without manual eviction.
@LazySingleton(as: LogoFileStore)
class LogoFileStoreImpl implements LogoFileStore {
  LogoFileStoreImpl(this._clock);

  static const String _source = 'LogoFileStore';

  final Clock _clock;

  @override
  Future<String> store(String sourcePath) async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(p.join(root.path, MediaConstants.logoDirectory));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    final name = '${MediaConstants.logoFilePrefix}${_clock.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final stored = await File(sourcePath).copy(p.join(directory.path, name));
    return stored.path;
  }

  @override
  Future<void> delete(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    } on FileSystemException catch (error) {
      AppLogger.warning(_source, 'could not delete old logo $error');
    }
  }
}
