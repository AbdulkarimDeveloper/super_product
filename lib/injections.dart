import 'package:get_it/get_it.dart';
import 'package:test_project/core/secure_storage_abs.dart';
import 'package:test_project/core/secure_storage_impl.dart';
import 'package:test_project/features/products/data/datasources/products_local_data_source.dart';
import 'package:test_project/features/products/data/models/product_model.dart';
import 'package:test_project/features/products/data/repositories/products_repository_impl.dart';
import 'package:test_project/features/products/domain/repositories/products_repository_abs.dart';
import 'package:test_project/features/products/presentation/controllers/products_controller.dart';

final getIt = GetIt.instance;

Future initInjection() async {
  getIt.registerLazySingleton<SecureStorageAbs>(() => SecureStorageImpl());

  //! Products
  getIt.registerLazySingleton<ProductsLocalDataSource>(
    () => ProductsLocalDataSource(storage: SecureStorageImpl<ProductModel>()),
  );

  getIt.registerLazySingleton<ProductsRepositoryAbs>(
    () => ProductsRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<ProductsController>(
    () => ProductsController(repository: getIt()),
  );
}
