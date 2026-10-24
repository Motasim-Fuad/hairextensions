part of 'library_cubit.dart';

final class LibraryState extends Equatable {
  const LibraryState({
    this.status = ViewStatus.loading,
    this.segment = LibrarySegment.products,
    this.sort = LibrarySort.recent,
    this.query = '',
    this.products = const [],
    this.materials = const [],
    this.services = const [],
  });

  final ViewStatus status;
  final LibrarySegment segment;
  final LibrarySort sort;
  final String query;
  final List<Product> products;
  final List<MaterialItem> materials;
  final List<ServiceTemplate> services;

  String get _needle => query.trim().toLowerCase();

  List<Product> get visibleProducts {
    final matches = products.where(
      (product) =>
          _needle.isEmpty ||
          product.name.toLowerCase().contains(_needle) ||
          product.colour.toLowerCase().contains(_needle),
    );
    final sorted = matches.toList()
      ..sort(
        (a, b) => sort == LibrarySort.name ? a.name.compareTo(b.name) : b.updatedAt.compareTo(a.updatedAt),
      );
    return sorted;
  }

  List<MaterialItem> get visibleMaterials =>
      materials.where((item) => _needle.isEmpty || item.name.toLowerCase().contains(_needle)).toList();

  List<ServiceTemplate> get visibleServices =>
      services.where((item) => _needle.isEmpty || item.name.toLowerCase().contains(_needle)).toList();

  int get visibleCount => switch (segment) {
    LibrarySegment.products => visibleProducts.length,
    LibrarySegment.materials => visibleMaterials.length,
    LibrarySegment.services => visibleServices.length,
  };

  LibraryState copyWith({
    ViewStatus? status,
    LibrarySegment? segment,
    LibrarySort? sort,
    String? query,
    List<Product>? products,
    List<MaterialItem>? materials,
    List<ServiceTemplate>? services,
  }) {
    return LibraryState(
      status: status ?? this.status,
      segment: segment ?? this.segment,
      sort: sort ?? this.sort,
      query: query ?? this.query,
      products: products ?? this.products,
      materials: materials ?? this.materials,
      services: services ?? this.services,
    );
  }

  @override
  List<Object?> get props => [status, segment, sort, query, products, materials, services];
}
