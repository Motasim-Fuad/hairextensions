part of 'failure.dart';

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message, super.statusCode}) : super(code: FailureCode.forbidden);
}
