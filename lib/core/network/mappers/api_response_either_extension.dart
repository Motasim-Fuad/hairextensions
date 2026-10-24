import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';

extension ApiResponseEitherExtension<T> on ApiResponse<T> {
  Either<Failure, R> toEither<R>(R Function(T data) onData) {
    if (isSuccess) {
      return Right(onData(data as T));
    }
    return Left(ApiFailureMapper.toFailure(this));
  }
}
