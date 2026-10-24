import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hairextensions/core/constants/location_constants.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/location/location_service.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/permissions/app_permission.dart';
import 'package:hairextensions/core/permissions/permission_service.dart';
import 'package:hairextensions/core/shared_entities/geo_point.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocationService)
class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService(this._permissions);

  static const String _source = 'LocationService';
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.medium,
    distanceFilter: LocationConstants.distanceFilterMeters,
    timeLimit: LocationConstants.fixTimeLimit,
  );

  final PermissionService _permissions;

  @override
  Future<Either<Failure, GeoPoint>> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const Left(LocationDisabledFailure());
    }
    final status = await _permissions.request(AppPermission.location);
    if (!status.isUsable) {
      return Left(PermissionDeniedFailure(isPermanent: status.needsSettings));
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _settings,
      );
      return Right(
        GeoPoint(latitude: position.latitude, longitude: position.longitude),
      );
    } on Object catch (error) {
      AppLogger.error(_source, 'position failed', error);
      return const Left(UnknownFailure());
    }
  }

  @override
  Stream<GeoPoint> watch() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: LocationConstants.distanceFilterMeters,
      ),
    ).map(
      (position) => GeoPoint(latitude: position.latitude, longitude: position.longitude),
    );
  }
}
