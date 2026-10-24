import 'package:equatable/equatable.dart';

class ConsentSettings extends Equatable {
  const ConsentSettings({
    required this.analyticsEnabled,
    required this.crashReportingEnabled,
    required this.hasAnswered,
  });

  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final bool hasAnswered;

  @override
  List<Object?> get props => [analyticsEnabled, crashReportingEnabled, hasAnswered];
}
