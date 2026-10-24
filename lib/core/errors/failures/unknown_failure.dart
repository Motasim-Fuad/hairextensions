part of 'failure.dart';

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message, super.statusCode}) : super(code: FailureCode.unknown);
}
