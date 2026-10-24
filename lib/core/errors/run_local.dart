import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/crash/non_fatal.dart';

/// Wraps a local database operation so repositories never leak exceptions.
Future<Either<Failure, T>> runLocal<T>(
  String source,
  Future<T> Function() action,
) async {
  try {
    return Right(await action());
  } on Object catch (error, stackTrace) {
    AppLogger.error(source, 'local operation failed', error);
    NonFatal.record(error, stackTrace, reason: source);
    return const Left(LocalStorageFailure());
  }
}
