part of 'add_item_cubit.dart';

final class AddItemState extends Equatable {
  const AddItemState({
    required this.category,
    this.materials = const [],
    this.materialId,
    this.name = '',
    this.quantity = 1,
    this.unitPriceMinor = 0,
    this.unitCostMinor = 0,
    this.isTaxable = true,
    this.showErrors = false,
  });

  final LineCategory category;
  final List<MaterialItem> materials;
  final String? materialId;
  final String name;
  final int quantity;
  final int unitPriceMinor;
  final int unitCostMinor;
  final bool isTaxable;
  final bool showErrors;

  int get amountMinor => quantity * unitPriceMinor;

  bool get showNameError => showErrors && name.trim().isEmpty;

  bool get showQuantityError => showErrors && quantity <= 0;

  bool get isValid => name.trim().isNotEmpty && quantity > 0;

  AddItemState copyWith({
    List<MaterialItem>? materials,
    String? materialId,
    String? name,
    int? quantity,
    int? unitPriceMinor,
    int? unitCostMinor,
    bool? isTaxable,
    bool? showErrors,
  }) {
    return AddItemState(
      category: category,
      materials: materials ?? this.materials,
      materialId: materialId ?? this.materialId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      unitCostMinor: unitCostMinor ?? this.unitCostMinor,
      isTaxable: isTaxable ?? this.isTaxable,
      showErrors: showErrors ?? this.showErrors,
    );
  }

  @override
  List<Object?> get props => [
    category,
    materials,
    materialId,
    name,
    quantity,
    unitPriceMinor,
    unitCostMinor,
    isTaxable,
    showErrors,
  ];
}
