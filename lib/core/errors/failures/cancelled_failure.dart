part of 'failure.dart';

final class CancelledFailure extends Failure {
  const CancelledFailure() : super(code: FailureCode.cancelled);
}
