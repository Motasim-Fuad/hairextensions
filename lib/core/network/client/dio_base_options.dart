import 'package:dio/dio.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/constants/network_constants.dart';

abstract final class DioBaseOptions {
  static BaseOptions from(AppConfig config) {
    return BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: {
        NetworkConstants.acceptHeader: NetworkConstants.jsonContentType,
      },
      contentType: NetworkConstants.jsonContentType,
    );
  }
}
