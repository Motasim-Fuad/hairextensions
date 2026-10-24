import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/library/data/demo/demo_catalog.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

/// In-memory library seeded with sample data so every screen can be demoed.
/// Swap for a sqflite-backed implementation without touching presentation.
@LazySingleton(as: LibraryRepository)
class DemoLibraryRepository implements LibraryRepository {
  DemoLibraryRepository(Clock clock) : _products = DemoCatalog.products(clock.now());

  List<Product> _products;
  final StreamController<List<Product>> _productChanges = StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchProducts() async* {
    yield _products;
    yield* _productChanges.stream;
  }

  @override
  Stream<List<MaterialItem>> watchMaterials() => Stream.value(DemoCatalog.materials);

  @override
  Stream<List<ServiceTemplate>> watchServices() => Stream.value(DemoCatalog.services);

  @override
  Future<Either<Failure, Product>> saveProduct(Product product) async {
    _products = [product, ..._products.where((existing) => existing.id != product.id)];
    _productChanges.add(_products);
    return Right(product);
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    _products = _products.where((existing) => existing.id != id).toList();
    _productChanges.add(_products);
    return const Right(unit);
  }
}
