import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@LazySingleton(as: LinkLauncher)
class UrlLinkLauncher implements LinkLauncher {
  static const String _source = 'UrlLinkLauncher';

  @override
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      AppLogger.warning(_source, 'invalid url');
      return false;
    }
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (error) {
      AppLogger.error(_source, 'launch failed', error);
      return false;
    }
  }
}
