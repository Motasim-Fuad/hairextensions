import 'package:equatable/equatable.dart';

/// A consumable used during an install (tape tabs, bonds, rings).
class MaterialItem extends Equatable {
  const MaterialItem({
    required this.id,
    required this.name,
    required this.unitCostMinor,
    required this.unitPriceMinor,
    required this.isTaxable,
  });

  final String id;
  final String name;
  final int unitCostMinor;
  final int unitPriceMinor;
  final bool isTaxable;

  @override
  List<Object?> get props => [id, name, unitCostMinor, unitPriceMinor, isTaxable];
}
