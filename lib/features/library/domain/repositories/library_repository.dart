import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/product.dart';

abstract interface class LibraryRepository implements CatalogReader {
  Future<Either<Failure, Product>> saveProduct(Product product);

  Future<Either<Failure, Unit>> deleteProduct(String id);
}
