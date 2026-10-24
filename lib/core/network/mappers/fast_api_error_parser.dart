import 'package:hairextensions/core/constants/network_constants.dart';

/// Reads FastAPI error bodies: {"detail": "text"} or
/// {"detail": [{"loc": ["body", "field"], "msg": "text"}]}.
abstract final class FastApiErrorParser {
  static const String _detailKey = 'detail';
  static const String _messageKey = 'message';
  static const String _msgKey = 'msg';
  static const String _locKey = 'loc';

  static String? message(Object? body) {
    if (body is Map) {
      final detail = body[_detailKey];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first[_msgKey] is String) {
          return first[_msgKey] as String;
        }
      }
      if (detail is Map && detail[_messageKey] is String) {
        return detail[_messageKey] as String;
      }
      final topMessage = body[_messageKey];
      if (topMessage is String && topMessage.isNotEmpty) {
        return topMessage;
      }
    }
    if (body is String && body.isNotEmpty && body.length <= NetworkConstants.maxPlainErrorLength) {
      return body;
    }
    return null;
  }

  static Map<String, String> fieldErrors(Object? body) {
    if (body is! Map) {
      return const {};
    }
    final detail = body[_detailKey];
    if (detail is! List) {
      return const {};
    }
    final errors = <String, String>{};
    for (final item in detail) {
      if (item is! Map) {
        continue;
      }
      final location = item[_locKey];
      final text = item[_msgKey];
      if (location is List && location.isNotEmpty && text is String) {
        errors.putIfAbsent(location.last.toString(), () => text);
      }
    }
    return errors;
  }
}
