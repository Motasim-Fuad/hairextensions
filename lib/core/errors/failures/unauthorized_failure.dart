part of 'failure.dart';

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message, super.statusCode}) : super(code: FailureCode.unauthorized);
}
