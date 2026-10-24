import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CatalogReader)
class CatalogReaderImpl implements CatalogReader {
  CatalogReaderImpl(this._repository);

  final LibraryRepository _repository;

  @override
  Stream<List<Product>> watchProducts() => _repository.watchProducts();

  @override
  Stream<List<MaterialItem>> watchMaterials() => _repository.watchMaterials();

  @override
  Stream<List<ServiceTemplate>> watchServices() => _repository.watchServices();
}
