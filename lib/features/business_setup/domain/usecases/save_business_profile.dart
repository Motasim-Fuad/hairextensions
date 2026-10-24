import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/features/business_setup/domain/repositories/business_profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveBusinessProfile {
  SaveBusinessProfile(this._repository);

  final BusinessProfileRepository _repository;

  Future<Either<Failure, Unit>> call(BusinessProfile profile, {required bool completeSetup}) {
    return _repository.saveProfile(profile, completeSetup: completeSetup);
  }
}
