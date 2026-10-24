import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/errors/failure_code.dart';

part 'cancelled_failure.dart';
part 'forbidden_failure.dart';
part 'local_storage_failure.dart';
part 'location_disabled_failure.dart';
part 'network_failure.dart';
part 'not_found_failure.dart';
part 'permission_denied_failure.dart';
part 'server_failure.dart';
part 'timeout_failure.dart';
part 'unauthorized_failure.dart';
part 'unknown_failure.dart';
part 'validation_failure.dart';

/// Base of every error a repository can return. [message] is a server provided
/// text when available; otherwise the UI localizes from [code].
sealed class Failure extends Equatable {
  const Failure({required this.code, this.message, this.statusCode});

  final FailureCode code;
  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [code, message, statusCode];
}
