import 'package:equatable/equatable.dart';
import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';

/// A hair product from the library. Shared because quotes price hair from it.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.type,
    required this.lengthInches,
    required this.colour,
    required this.soldBy,
    required this.packPriceMinor,
    required this.unitsPerPack,
    required this.pricingMode,
    required this.markupPercent,
    required this.retailPerUnitMinor,
    required this.isTaxable,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final HairType type;
  final int lengthInches;
  final String colour;
  final SoldBy soldBy;
  final int packPriceMinor;
  final int unitsPerPack;
  final PricingMode pricingMode;
  final double markupPercent;
  final int retailPerUnitMinor;
  final bool isTaxable;
  final DateTime updatedAt;

  /// Cost of one gram (or one piece), in minor units.
  int get costPerUnitMinor => unitsPerPack <= 0 ? 0 : (packPriceMinor / unitsPerPack).round();

  Product copyWith({
    String? name,
    HairType? type,
    int? lengthInches,
    String? colour,
    SoldBy? soldBy,
    int? packPriceMinor,
    int? unitsPerPack,
    PricingMode? pricingMode,
    double? markupPercent,
    int? retailPerUnitMinor,
    bool? isTaxable,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      lengthInches: lengthInches ?? this.lengthInches,
      colour: colour ?? this.colour,
      soldBy: soldBy ?? this.soldBy,
      packPriceMinor: packPriceMinor ?? this.packPriceMinor,
      unitsPerPack: unitsPerPack ?? this.unitsPerPack,
      pricingMode: pricingMode ?? this.pricingMode,
      markupPercent: markupPercent ?? this.markupPercent,
      retailPerUnitMinor: retailPerUnitMinor ?? this.retailPerUnitMinor,
      isTaxable: isTaxable ?? this.isTaxable,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    lengthInches,
    colour,
    soldBy,
    packPriceMinor,
    unitsPerPack,
    pricingMode,
    markupPercent,
    retailPerUnitMinor,
    isTaxable,
    updatedAt,
  ];
}
