part of 'failure.dart';

/// [fieldErrors] maps a field name to its message so forms can show the text
/// directly below the related input.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message,
    super.statusCode,
    this.fieldErrors = const {},
  }) : super(code: FailureCode.validation);

  final Map<String, String> fieldErrors;

  String? errorFor(String field) => fieldErrors[field];

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}
