import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';

abstract interface class BusinessProfileRepository {
  Future<Either<Failure, BusinessProfile?>> getProfile();

  /// Saves locally first and queues the change for sync. [completeSetup]
  /// marks first-launch setup as finished for the router guard.
  Future<Either<Failure, Unit>> saveProfile(BusinessProfile profile, {required bool completeSetup});

  /// Copies the picked image into app storage. Right(null) means cancelled.
  Future<Either<Failure, String?>> pickLogo();
}
