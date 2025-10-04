import 'package:test_project/features/products/data/datasources/products_local_data_source.dart';
import 'package:test_project/features/products/data/models/product_model.dart';
import 'package:test_project/features/products/domain/repositories/products_repository_abs.dart';

class ProductsRepositoryImpl extends ProductsRepositoryAbs {
  ProductsRepositoryImpl({required this.localDataSource});
  ProductsLocalDataSource localDataSource;
  //! can use other dataSources: remote , firebase

  @override
  Future<bool> add(ProductModel item) {
    return localDataSource.add(item);
  }

  @override
  Future<bool> update(ProductModel item) {
    return localDataSource.update(item);
  }

  @override
  Future<bool> delete(ProductModel item) {
    return localDataSource.delete(item);
  }

  @override
  Future<List<ProductModel>> getAll() {
    return localDataSource.getAll();
  }

  @override
  Future<bool> addAll(List<ProductModel> items) {
    return localDataSource.addAll(items);
  }
}
