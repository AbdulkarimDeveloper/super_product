import 'package:test_project/core/secure_storage_abs.dart';
import 'package:test_project/features/products/data/models/product_model.dart';

class ProductsLocalDataSource {
  ProductsLocalDataSource({required this.storage});

  SecureStorageAbs<ProductModel> storage;
  final key = "products_key";

  Future<bool> add(ProductModel item) {
    return storage.add(
      key,
      item,
      ProductModel.parseFromString,
      ProductModel.parseToString,
    );
  }

  Future<bool> update(ProductModel item) {
    return storage.update(
      key,
      item,
      ProductModel.parseFromString,
      ProductModel.parseToString,
      (item) => item.id,
    );
  }

  Future<bool> delete(ProductModel item) {
    return storage.delete(
      key,
      item,
      ProductModel.parseFromString,
      ProductModel.parseToString,
      (item) => item.id,
    );
  }

  Future<List<ProductModel>> getAll() {
    return storage.getAll(key, ProductModel.parseFromString);
  }

  Future<bool> addAll(List<ProductModel> items) {
    return storage.addAll(
      key,
      items,
      ProductModel.parseFromString,
      ProductModel.parseToString,
    );
  }
}
