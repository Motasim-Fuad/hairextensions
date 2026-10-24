import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/features/business_setup/domain/repositories/business_profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PickBusinessLogo {
  PickBusinessLogo(this._repository);

  final BusinessProfileRepository _repository;

  Future<Either<Failure, String?>> call() => _repository.pickLogo();
}
