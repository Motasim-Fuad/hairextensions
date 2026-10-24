import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';

abstract final class ApiFailureMapper {
  static Failure toFailure(ApiResponse<Object?> response) {
    switch (response.errorType) {
      case ApiErrorType.cancelled:
        return const CancelledFailure();
      case ApiErrorType.timeout:
        return const TimeoutFailure();
      case ApiErrorType.network:
      case ApiErrorType.badCertificate:
        return const NetworkFailure();
      case ApiErrorType.none:
      case ApiErrorType.badResponse:
      case ApiErrorType.parsing:
      case ApiErrorType.unknown:
        break;
    }
    final message = response.message;
    final statusCode = response.statusCode;
    if (response.isUnauthorized) {
      return UnauthorizedFailure(message: message, statusCode: statusCode);
    }
    if (response.isForbidden) {
      return ForbiddenFailure(message: message, statusCode: statusCode);
    }
    if (response.isNotFound) {
      return NotFoundFailure(message: message, statusCode: statusCode);
    }
    if (response.isValidationError) {
      return ValidationFailure(
        message: message,
        statusCode: statusCode,
        fieldErrors: response.fieldErrors,
      );
    }
    if (response.isServerError) {
      return ServerFailure(message: message, statusCode: statusCode);
    }
    return UnknownFailure(message: message, statusCode: statusCode);
  }
}
