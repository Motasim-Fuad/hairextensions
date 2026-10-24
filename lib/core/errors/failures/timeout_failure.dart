part of 'failure.dart';

final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(code: FailureCode.timeout);
}
