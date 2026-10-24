part of 'product_form_cubit.dart';

final class ProductFormState extends Equatable {
  const ProductFormState({
    required this.product,
    required this.isNew,
    this.showErrors = false,
    this.isSaving = false,
    this.isDone = false,
    this.failure,
  });

  final Product product;
  final bool isNew;
  final bool showErrors;
  final bool isSaving;

  /// Saved or deleted; the screen should close.
  final bool isDone;
  final Failure? failure;

  bool get showNameError => showErrors && product.name.trim().isEmpty;

  bool get showPriceError => showErrors && product.packPriceMinor <= 0;

  bool get showUnitsError => showErrors && product.unitsPerPack <= 0;

  bool get isValid => product.name.trim().isNotEmpty && product.packPriceMinor > 0 && product.unitsPerPack > 0;

  ProductFormState copyWith({
    Product? product,
    bool? showErrors,
    bool? isSaving,
    bool? isDone,
    Failure? failure,
  }) {
    return ProductFormState(
      product: product ?? this.product,
      isNew: isNew,
      showErrors: showErrors ?? this.showErrors,
      isSaving: isSaving ?? this.isSaving,
      isDone: isDone ?? this.isDone,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [product, isNew, showErrors, isSaving, isDone, failure];
}
