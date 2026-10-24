part of 'add_hair_cubit.dart';

final class AddHairState extends Equatable {
  const AddHairState({
    this.products = const [],
    this.product,
    this.wholePack = true,
    this.grams = 0,
    this.pricingMode = PricingMode.markup,
    this.markupPercent = 0,
    this.retailMinor = 0,
    this.isTaxable = true,
    this.showErrors = false,
  });

  static const String previewId = 'preview';

  final List<Product> products;
  final Product? product;
  final bool wholePack;
  final int grams;
  final PricingMode pricingMode;
  final double markupPercent;
  final int retailMinor;
  final bool isTaxable;
  final bool showErrors;

  bool get isValid => product != null && grams > 0;

  bool get showGramsError => showErrors && grams <= 0;

  /// Live result of the current inputs.
  QuoteLine? get preview {
    final selected = product;
    if (selected == null) {
      return null;
    }
    return QuoteLineFactory.hair(
      id: previewId,
      product: selected,
      grams: grams,
      wholePack: wholePack,
      pricingMode: pricingMode,
      markupPercent: markupPercent,
      retailPriceMinor: retailMinor,
      isTaxable: isTaxable,
    );
  }

  AddHairState copyWith({
    List<Product>? products,
    Product? product,
    bool? wholePack,
    int? grams,
    PricingMode? pricingMode,
    double? markupPercent,
    int? retailMinor,
    bool? isTaxable,
    bool? showErrors,
  }) {
    return AddHairState(
      products: products ?? this.products,
      product: product ?? this.product,
      wholePack: wholePack ?? this.wholePack,
      grams: grams ?? this.grams,
      pricingMode: pricingMode ?? this.pricingMode,
      markupPercent: markupPercent ?? this.markupPercent,
      retailMinor: retailMinor ?? this.retailMinor,
      isTaxable: isTaxable ?? this.isTaxable,
      showErrors: showErrors ?? this.showErrors,
    );
  }

  @override
  List<Object?> get props => [
    products,
    product,
    wholePack,
    grams,
    pricingMode,
    markupPercent,
    retailMinor,
    isTaxable,
    showErrors,
  ];
}
