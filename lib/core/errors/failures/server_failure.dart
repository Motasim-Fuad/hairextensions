part of 'failure.dart';

final class ServerFailure extends Failure {
  const ServerFailure({super.message, super.statusCode}) : super(code: FailureCode.server);
}
