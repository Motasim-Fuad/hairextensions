import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/features/library/data/mappers/library_item_mapper.dart';
import 'package:hairextensions/features/library/data/models/library_item_dto.dart';

void main() {
  test('a product survives the trip through the API fields', () {
    final product = Product(
      id: 'local',
      name: 'Russian Tape-in',
      type: HairType.keratin,
      lengthInches: 20,
      colour: '#1B',
      soldBy: SoldBy.pieces,
      packPriceMinor: 24000,
      unitsPerPack: 40,
      pricingMode: PricingMode.retail,
      markupPercent: 60,
      retailPerUnitMinor: 900,
      isTaxable: true,
      updatedAt: DateTime.utc(2026, 10, 24),
    );

    final body = LibraryItemMapper.productToApi(product);
    final back = LibraryItemMapper.toProduct(
      LibraryItemDto.fromJson({
        'id': 5,
        'name': body['name'],
        'kind': body['kind'],
        'taxable': body['taxable'],
        'updated_at': '2026-10-24T00:00:00Z',
        'description': body['description'],
        'category': body['category'],
        'grams_per_pack': body['grams_per_pack'],
        'pack_price': body['pack_price'],
        'markup_percent': body['markup_percent'],
        'unit_price': body['unit_price'],
        'unit_label': body['unit_label'],
      }),
    );

    expect(body['kind'], 'hair');
    expect(body['pack_price'], '240.00');
    expect(back.id, '5');
    expect(back.name, product.name);
    expect(back.type, HairType.keratin);
    expect(back.lengthInches, 20);
    expect(back.colour, '#1B');
    expect(back.soldBy, SoldBy.pieces);
    expect(back.packPriceMinor, 24000);
    expect(back.unitsPerPack, 40);
    expect(back.pricingMode, PricingMode.retail);
    expect(back.retailPerUnitMinor, 900);
  });

  test('an item with no stored details falls back to safe defaults', () {
    final product = LibraryItemMapper.toProduct(
      LibraryItemDto.fromJson({
        'id': 9,
        'name': 'Imported',
        'kind': 'hair',
        'taxable': true,
        'updated_at': '2026-10-24T00:00:00Z',
        'description': 'not json',
      }),
    );

    expect(product.pricingMode, PricingMode.markup);
    expect(product.colour, '');
    expect(product.soldBy, SoldBy.grams);
  });
}
