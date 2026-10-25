import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';

/// Connects sign-in to the business profile without auth importing
/// business_setup. Implemented by business_setup.
abstract interface class AccountRestorer {
  /// Pulls the signed-in account's business from the server into local storage
  /// and marks setup as completed. Right(true) when the account already has a
  /// business, Right(false) when it still has to create one.
  Future<Either<Failure, bool>> restore();

  /// For a signed-in account whose business never reached the server (for
  /// example a rejected first push): queues the local profile again.
  Future<void> syncMissingBusiness();

  /// Forgets the previous account's local business data.
  Future<void> clearLocal();
}
