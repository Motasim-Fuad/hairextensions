import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/geo_point.dart';

/// One-shot position by default. [watch] must only be listened to while the
/// screen is visible and the subscription cancelled in dispose.
abstract interface class LocationService {
  Future<Either<Failure, GeoPoint>> currentPosition();

  Stream<GeoPoint> watch();
}
