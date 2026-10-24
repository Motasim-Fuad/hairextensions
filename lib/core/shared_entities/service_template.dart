import 'package:equatable/equatable.dart';

/// A reusable labor item: hourly (rate × hours) or a flat fee (rate only).
class ServiceTemplate extends Equatable {
  const ServiceTemplate({
    required this.id,
    required this.name,
    required this.isHourly,
    required this.rateMinor,
    required this.hours,
    required this.isTaxable,
  });

  final String id;
  final String name;
  final bool isHourly;
  final int rateMinor;
  final double hours;
  final bool isTaxable;

  int get chargeMinor => isHourly ? (rateMinor * hours).round() : rateMinor;

  @override
  List<Object?> get props => [id, name, isHourly, rateMinor, hours, isTaxable];
}
