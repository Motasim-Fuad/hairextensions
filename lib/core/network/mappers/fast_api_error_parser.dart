import 'package:hairextensions/core/constants/network_constants.dart';

/// Reads the Price to Profit error envelope
///   {"error": {"code": "...", "message": "...", "details": [{"location": [...], "message": "..."}]}}
/// and still understands plain FastAPI bodies ({"detail": ...}) as a fallback.
abstract final class FastApiErrorParser {
  static const String _errorKey = 'error';
  static const String _codeKey = 'code';
  static const String _detailKey = 'detail';
  static const String _detailsKey = 'details';
  static const String _messageKey = 'message';
  static const String _msgKey = 'msg';
  static const String _locKey = 'loc';
  static const String _locationKey = 'location';

  static Map<Object?, Object?>? _envelope(Object? body) {
    if (body is Map) {
      final error = body[_errorKey];
      if (error is Map) {
        return error;
      }
    }
    return null;
  }

  /// Stable machine readable code such as `not_found` or `conflict`.
  static String? code(Object? body) {
    final value = _envelope(body)?[_codeKey];
    return value is String && value.isNotEmpty ? value : null;
  }

  static String? message(Object? body) {
    final envelope = _envelope(body);
    if (envelope != null) {
      final text = envelope[_messageKey];
      if (text is String && text.isNotEmpty) {
        return text;
      }
    }
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

  /// Field name -> message, taken from `error.details` (or FastAPI `detail`).
  static Map<String, String> fieldErrors(Object? body) {
    final errors = <String, String>{};
    final envelope = _envelope(body);
    final details = envelope?[_detailsKey];
    if (details is List) {
      for (final item in details) {
        if (item is! Map) {
          continue;
        }
        final location = item[_locationKey];
        final text = item[_messageKey];
        if (location is List && location.isNotEmpty && text is String) {
          errors.putIfAbsent(location.last.toString(), () => text);
        }
      }
      return errors;
    }
    if (body is! Map) {
      return const {};
    }
    final detail = body[_detailKey];
    if (detail is! List) {
      return const {};
    }
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
