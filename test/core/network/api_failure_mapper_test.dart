import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';

void main() {
  test('maps network errors before status codes', () {
    final response = ApiResponse<void>.failure(errorType: ApiErrorType.network);

    expect(ApiFailureMapper.toFailure(response), isA<NetworkFailure>());
    expect(response.isNetworkError, isTrue);
  });

  test('maps 401 to unauthorized with server message', () {
    final response = ApiResponse<void>.failure(statusCode: 401, message: 'Token expired');
    final failure = ApiFailureMapper.toFailure(response);

    expect(response.isUnauthorized, isTrue);
    expect(failure, isA<UnauthorizedFailure>());
    expect(failure.message, 'Token expired');
  });

  test('maps 422 to validation with field errors', () {
    final response = ApiResponse<void>.failure(statusCode: 422, fieldErrors: {'email': 'invalid'});
    final failure = ApiFailureMapper.toFailure(response);

    expect(failure, isA<ValidationFailure>());
    expect((failure as ValidationFailure).errorFor('email'), 'invalid');
  });

  test('maps 503 to server failure and marks it transient', () {
    final response = ApiResponse<void>.failure(statusCode: 503);

    expect(ApiFailureMapper.toFailure(response), isA<ServerFailure>());
    expect(response.isServerError, isTrue);
    expect(response.isTransient, isTrue);
  });

  test('success exposes data and status', () {
    final response = ApiResponse.success(42);

    expect(response.isSuccess, isTrue);
    expect(response.statusCode, 200);
    expect(response.data, 42);
  });
}
