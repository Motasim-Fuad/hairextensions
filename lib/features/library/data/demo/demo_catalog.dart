import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';

/// Sample library shown until the local database feature replaces the demo
/// repository. Product names are brand data, not UI copy.
abstract final class DemoCatalog {
  static const double _defaultMarkup = 60;

  static List<Product> products(DateTime now) {
    Product item(
      int index,
      String name,
      HairType type,
      int length,
      String colour,
      int packPriceMinor,
      int units, {
      SoldBy soldBy = SoldBy.grams,
    }) {
      return Product(
        id: 'product-$index',
        name: name,
        type: type,
        lengthInches: length,
        colour: colour,
        soldBy: soldBy,
        packPriceMinor: packPriceMinor,
        unitsPerPack: units,
        pricingMode: PricingMode.markup,
        markupPercent: _defaultMarkup,
        retailPerUnitMinor: 0,
        isTaxable: true,
        updatedAt: now.subtract(Duration(days: index)),
      );
    }

    return [
      item(1, 'Luxe Tape-In 22”', HairType.tapeIn, 22, '#60 Platinum', 35000, 100),
      item(2, 'Silk Keratin Bonds 20”', HairType.keratin, 20, '#8 Chestnut', 42000, 100, soldBy: SoldBy.pieces),
      item(3, 'Genius Weft 24”', HairType.weft, 24, '#1B Natural Black', 52000, 120),
      item(4, 'Nano Ring 18”', HairType.iTip, 18, '#613 Blonde', 30000, 100),
      item(5, 'Clip-In Set 20”', HairType.clipIn, 20, '#4 Mocha', 69000, 160),
      item(6, 'Luxe Tape-In 18”', HairType.tapeIn, 18, '#18 Ash Blonde', 29000, 100),
      item(7, 'Invisible Tape-In 24”', HairType.tapeIn, 24, '#2 Dark Brown', 41000, 100),
      item(8, 'Silk Keratin Bonds 24”', HairType.keratin, 24, '#60 Platinum', 48000, 100, soldBy: SoldBy.pieces),
      item(9, 'Hand-Tied Weft 20”', HairType.weft, 20, '#6 Caramel', 46000, 100),
      item(10, 'Micro I-Tip 22”', HairType.iTip, 22, '#10 Honey', 34000, 100),
      item(11, 'Volume Clip-In 18”', HairType.clipIn, 18, '#1 Jet Black', 55000, 140),
      item(12, 'Balayage Tape-In 22”', HairType.tapeIn, 22, '#4/27 Balayage', 38000, 100),
    ];
  }

  static const List<MaterialItem> materials = [
    MaterialItem(
      id: 'material-1',
      name: 'Tape tabs refill',
      unitCostMinor: 2000,
      unitPriceMinor: 4000,
      isTaxable: true,
    ),
    MaterialItem(
      id: 'material-2',
      name: 'Keratin glue sticks',
      unitCostMinor: 1500,
      unitPriceMinor: 3000,
      isTaxable: true,
    ),
    MaterialItem(
      id: 'material-3',
      name: 'Micro rings (100)',
      unitCostMinor: 2500,
      unitPriceMinor: 5000,
      isTaxable: true,
    ),
    MaterialItem(id: 'material-4', name: 'Tape remover', unitCostMinor: 3000, unitPriceMinor: 6000, isTaxable: true),
    MaterialItem(id: 'material-5', name: 'Bond remover', unitCostMinor: 3500, unitPriceMinor: 7000, isTaxable: true),
    MaterialItem(id: 'material-6', name: 'Aftercare kit', unitCostMinor: 6000, unitPriceMinor: 12000, isTaxable: true),
  ];

  static const List<ServiceTemplate> services = [
    ServiceTemplate(
      id: 'service-1',
      name: 'Full head tape-in install',
      isHourly: true,
      rateMinor: 18000,
      hours: 3.5,
      isTaxable: true,
    ),
    ServiceTemplate(id: 'service-2', name: 'Half head', isHourly: true, rateMinor: 18000, hours: 2, isTaxable: true),
    ServiceTemplate(id: 'service-3', name: 'Move-up', isHourly: true, rateMinor: 16000, hours: 1.5, isTaxable: true),
    ServiceTemplate(
      id: 'service-4',
      name: 'Toning & blend',
      isHourly: false,
      rateMinor: 15000,
      hours: 0,
      isTaxable: true,
    ),
  ];
}
