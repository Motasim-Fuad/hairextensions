part of 'failure.dart';

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message, super.statusCode}) : super(code: FailureCode.notFound);
}
