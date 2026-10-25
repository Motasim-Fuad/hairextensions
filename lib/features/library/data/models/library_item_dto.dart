import 'package:hairextensions/core/utils/money_codec.dart';

/// One row of `GET /v1/library`: a hair product, labour rate, service,
/// material or fee. Fields that do not apply to a kind are null.
class LibraryItemDto {
  const LibraryItemDto({
    required this.id,
    required this.name,
    required this.kind,
    required this.taxable,
    required this.updatedAt,
    this.description,
    this.category,
    this.gramsPerPack,
    this.packPrice,
    this.markupPercent,
    this.hourlyRate,
    this.unitPrice,
    this.unitCost,
    this.unitLabel,
  });

  factory LibraryItemDto.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    return LibraryItemDto(
      id: (map['id'] as num).toInt(),
      name: map['name'] as String,
      kind: map['kind'] as String,
      taxable: map['taxable'] as bool? ?? true,
      updatedAt: DateTime.tryParse('${map['updated_at'] ?? ''}') ?? DateTime.now(),
      description: map['description'] as String?,
      category: map['category'] as String?,
      gramsPerPack: MoneyCodec.toDoubleOrNull(map['grams_per_pack']),
      packPrice: MoneyCodec.toMinorOrNull(map['pack_price']),
      markupPercent: MoneyCodec.toDoubleOrNull(map['markup_percent']),
      hourlyRate: MoneyCodec.toMinorOrNull(map['hourly_rate']),
      unitPrice: MoneyCodec.toMinorOrNull(map['unit_price']),
      unitCost: MoneyCodec.toMinorOrNull(map['unit_cost']),
      unitLabel: map['unit_label'] as String?,
    );
  }

  static const String hair = 'hair';
  static const String labour = 'labour';
  static const String service = 'service';
  static const String material = 'material';

  final int id;
  final String name;
  final String kind;
  final bool taxable;
  final DateTime updatedAt;
  final String? description;
  final String? category;
  final double? gramsPerPack;
  final int? packPrice;
  final double? markupPercent;
  final int? hourlyRate;
  final int? unitPrice;
  final int? unitCost;
  final String? unitLabel;
}
