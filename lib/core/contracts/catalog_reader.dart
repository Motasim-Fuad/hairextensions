import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';

/// Read-only access to the library for features other than library (quote
/// builder, settings counts). Each stream emits the current list first.
abstract interface class CatalogReader {
  Stream<List<Product>> watchProducts();

  Stream<List<MaterialItem>> watchMaterials();

  Stream<List<ServiceTemplate>> watchServices();
}
