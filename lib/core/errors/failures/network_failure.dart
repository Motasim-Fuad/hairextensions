part of 'failure.dart';

final class NetworkFailure extends Failure {
  const NetworkFailure() : super(code: FailureCode.network);
}
