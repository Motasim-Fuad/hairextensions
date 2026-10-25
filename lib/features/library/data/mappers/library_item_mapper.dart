import 'dart:convert';

import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/pricing_mode.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/core/utils/money_codec.dart';
import 'package:hairextensions/features/library/data/models/library_item_dto.dart';

/// The API library has no hair type, length, colour or pricing mode. Those
/// app-only details travel inside two spare text fields: the hair type in
/// `category`, and the rest as a small JSON object in `description`.
abstract final class LibraryItemMapper {
  static const String _gramLabel = 'g';
  static const String _pieceLabel = 'pc';
  static const String _lengthKey = 'length_in';
  static const String _colourKey = 'colour';
  static const String _modeKey = 'pricing_mode';
  static const double _defaultHours = 1;

  static Product toProduct(LibraryItemDto dto) {
    final meta = _meta(dto.description);
    final pricingMode = PricingMode.values.firstWhere(
      (mode) => mode.name == meta[_modeKey],
      orElse: () => PricingMode.markup,
    );
    return Product(
      id: '${dto.id}',
      name: dto.name,
      type: HairType.values.firstWhere((type) => type.name == dto.category, orElse: () => HairType.tapeIn),
      lengthInches: (meta[_lengthKey] as num?)?.toInt() ?? 0,
      colour: meta[_colourKey] as String? ?? '',
      soldBy: dto.unitLabel == _pieceLabel ? SoldBy.pieces : SoldBy.grams,
      packPriceMinor: dto.packPrice ?? 0,
      unitsPerPack: (dto.gramsPerPack ?? 0).round(),
      pricingMode: pricingMode,
      markupPercent: dto.markupPercent ?? 0,
      retailPerUnitMinor: dto.unitPrice ?? 0,
      isTaxable: dto.taxable,
      updatedAt: dto.updatedAt,
    );
  }

  static MaterialItem toMaterial(LibraryItemDto dto) {
    return MaterialItem(
      id: '${dto.id}',
      name: dto.name,
      unitCostMinor: dto.unitCost ?? 0,
      unitPriceMinor: dto.unitPrice ?? 0,
      isTaxable: dto.taxable,
    );
  }

  static ServiceTemplate toService(LibraryItemDto dto) {
    final isHourly = dto.kind == LibraryItemDto.labour;
    return ServiceTemplate(
      id: '${dto.id}',
      name: dto.name,
      isHourly: isHourly,
      rateMinor: (isHourly ? dto.hourlyRate : dto.unitPrice) ?? 0,
      hours: isHourly ? _defaultHours : 0,
      isTaxable: dto.taxable,
    );
  }

  /// Body for `POST /v1/library` and `PATCH /v1/library/{id}`.
  static Map<String, Object?> productToApi(Product product) {
    return {
      'kind': LibraryItemDto.hair,
      'name': product.name,
      'category': product.type.name,
      'description': jsonEncode({
        _lengthKey: product.lengthInches,
        _colourKey: product.colour,
        _modeKey: product.pricingMode.name,
      }),
      'taxable': product.isTaxable,
      'grams_per_pack': product.unitsPerPack.toString(),
      'pack_price': MoneyCodec.toApi(product.packPriceMinor),
      'markup_percent': MoneyCodec.decimalToApi(product.markupPercent),
      'unit_price': MoneyCodec.toApi(product.retailPerUnitMinor),
      'unit_label': product.soldBy == SoldBy.pieces ? _pieceLabel : _gramLabel,
    };
  }

  static Map<String, Object?> _meta(String? description) {
    if (description == null || description.isEmpty) {
      return const {};
    }
    try {
      final decoded = jsonDecode(description);
      return decoded is Map<String, Object?> ? decoded : const {};
    } on FormatException {
      return const {};
    }
  }
}
