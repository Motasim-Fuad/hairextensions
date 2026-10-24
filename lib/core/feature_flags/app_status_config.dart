import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/feature_flags/app_version.dart';

class AppStatusConfig extends Equatable {
  const AppStatusConfig({
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.maintenanceEnabled,
    required this.maintenanceMessage,
    required this.storeUrl,
  });

  final AppVersion minSupportedVersion;
  final AppVersion latestVersion;
  final bool maintenanceEnabled;
  final String maintenanceMessage;
  final String storeUrl;

  @override
  List<Object?> get props => [minSupportedVersion, latestVersion, maintenanceEnabled, maintenanceMessage, storeUrl];
}
