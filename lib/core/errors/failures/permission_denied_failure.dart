part of 'failure.dart';

final class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({this.isPermanent = false}) : super(code: FailureCode.permissionDenied);

  final bool isPermanent;

  @override
  List<Object?> get props => [...super.props, isPermanent];
}
