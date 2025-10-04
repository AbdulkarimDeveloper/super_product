import 'package:flutter/material.dart';
import 'package:test_project/core/enmus.dart';
import 'package:test_project/features/products/data/models/product_enums.dart';
import 'package:test_project/features/products/data/models/product_model.dart';
import 'package:test_project/features/products/data/models/product_type_model.dart';
import 'package:test_project/features/products/domain/repositories/products_repository_abs.dart';
import 'package:test_project/helpers/shared_preferences_helper.dart';

class ProductsController extends ChangeNotifier {
  ProductsController({required this.repository});
  final ProductsRepositoryAbs repository;

  //------------------ * Variables * ------------------//
  bool isList = true;
  ScreenType screenType = ScreenType.loading;

  List<ProductModel> _items = [];
  List<ProductModel> _currentItems = [];

  ProductTypeModel? currentProductType;
  List<ProductTypeModel> productTypesList = [
    ProductTypeModel(name: 'تصنيف كبير', type: ProductEnums.large),
    ProductTypeModel(name: 'تصنيف وسط', type: ProductEnums.medium),
    ProductTypeModel(name: 'تصنيف صغير', type: ProductEnums.small),
  ];

  //------------------ * Getters * ------------------//
  List<ProductModel> items() => _items;
  List<ProductModel> currentItems() => _currentItems;

  //------------------ * Repository Operations * ------------------//
  Future<List<ProductModel>> getAll() async {
    return repository.getAll();
  }

  Future<bool> add(ProductModel model) async {
    final res = await repository.add(model);
    if (res) {
      _items.add(model);

      if (currentProductType == null) {
        _currentItems.add(model);
        screenType = ScreenType.success;
      } else {
        if (currentProductType!.type == model.type) {
          _currentItems.add(model);
          screenType = ScreenType.success;
        }
      }

      notifyListeners();
    }
    return res;
  }

  Future<bool> update(ProductModel model) async {
    final res = await repository.update(model);
    if (res) {
      int indexItems = _items.indexWhere((element) => element.id == model.id);
      if (indexItems > -1) {
        _items[indexItems] = model;
      }

      int indexCurrentItems = _currentItems.indexWhere(
        (element) => element.id == model.id,
      );
      if (indexCurrentItems > -1) {
        _currentItems[indexCurrentItems] = model;
      }

      screenType = ScreenType.success;
      notifyListeners();
    }
    return res;
  }

  Future<bool> delete(ProductModel model) async {
    final res = await repository.delete(model);
    if (res) {
      int indexItems = _items.indexWhere((element) => element.id == model.id);
      if (indexItems > -1) {
        _items.removeAt(indexItems);
      }

      int indexCurrentItems = _currentItems.indexWhere(
        (element) => element.id == model.id,
      );
      if (indexCurrentItems > -1) {
        _currentItems.removeAt(indexCurrentItems);
      }

      if(_currentItems.isEmpty){
        screenType = ScreenType.noData;
      }
      else {
        screenType = ScreenType.success;
      }

      notifyListeners();
    }
    return res;
  }

  //------------------ * Controller Operations * ------------------//
  Future<void> init() async {
    isList = await SharedPreferencesHelper.instance.getIsList();
  }

  Future<void> refresh() async {
    screenType = ScreenType.loading;
    _items.clear();
    _currentItems.clear();
    notifyListeners();

    _items = await getAll();

    if (currentProductType != null) {
      _currentItems = _items
          .where((element) => element.type == currentProductType!.type)
          .toList();
    } else {
      _currentItems = [..._items];
    }

    if (_currentItems.isEmpty) {
      screenType = ScreenType.noData;
      notifyListeners();
    } else {
      screenType = ScreenType.success;
      notifyListeners();
    }
  }

  setProductType(ProductTypeModel? model) {
    currentProductType = model;
    if (currentProductType != null) {
      _currentItems = _items
          .where((element) => element.type == currentProductType!.type)
          .toList();
    } else {
      _currentItems = [..._items];
    }
    notifyListeners();
  }

  setIsList() {
    isList = !isList;
    SharedPreferencesHelper.instance.setIsList(isList);
    notifyListeners();
  }
}
