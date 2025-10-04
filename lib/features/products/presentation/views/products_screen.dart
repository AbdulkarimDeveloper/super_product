import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:test_project/core/enmus.dart';
import 'package:test_project/features/products/data/models/product_model.dart';
import 'package:test_project/features/products/data/models/product_type_model.dart';
import 'package:test_project/features/products/presentation/controllers/products_controller.dart';
import 'package:test_project/injections.dart';
import 'package:test_project/features/products/presentation/views/product_item.dart';
import 'package:test_project/widgets/failure_widget.dart';
import 'package:test_project/widgets/loading_widget.dart';
import 'package:test_project/widgets/no_data_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        getIt<ProductsController>().refresh();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsController>(
      builder: (context, controller, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: _appBar(),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------ * Title * ------------------//
                _title(),
                spaceH(),
                //------------------ * Types * ------------------//
                _listTypes(controller),
                spaceH(),
                //------------------ * Update State of List * ------------------//
                _filterCard(controller),
                spaceH(),
                //------------------ * All Products * ------------------//
                _products(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.grey[200],
      title: Text('المنتجات'),
      shadowColor: Colors.transparent,
      centerTitle: true,
      actions: [boxAppBar()],
    );
  }

  Widget boxAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductItem(model: null)),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(4),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _title() {
    return Text('التصنيفات', style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _listTypes(ProductsController controller) {
    return SizedBox(
      width: maxWidth(),
      height: 125,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: controller.productTypesList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _listTypeItem(index, null, controller),
                _listTypeItem(
                  index,
                  controller.productTypesList[index],
                  controller,
                ),
              ],
            );
          }
          return _listTypeItem(
            index,
            controller.productTypesList[index],
            controller,
          );
        },
      ),
    );
  }

  Widget _listTypeItem(
    int index,
    ProductTypeModel? model,
    ProductsController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          controller.setProductType(model);
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
              color: controller.currentProductType == null && model == null
                  ? Colors.green
                  : controller.currentProductType != null &&
                        controller.currentProductType?.type == model?.type
                  ? Colors.green
                  : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: Image.network(
                  'https://picsum.photos/200/300',
                  width: 80,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                model == null ? 'عرض الكل' : model.name,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterCard(ProductsController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              controller.setIsList();
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Icon(Icons.dashboard, color: Colors.red),
                  spaceW(),
                  Text(
                    'تغيير عرض المنتجات الى ${controller.isList ? "افقي" : "عامودي"}',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _products(ProductsController controller) {
    return Expanded(
      child: Builder(
        builder: (context) {
          switch (controller.screenType) {
            case ScreenType.loading:
              {
                return Center(child: LoadingWidget());
              }
            case ScreenType.noData:
              {
                return Center(
                  child: NoDataWidget(onTap: () => controller.refresh()),
                );
              }
            case ScreenType.error:
              {
                return Center(
                  child: FailureWidget(onTap: () => controller.refresh()),
                );
              }
            case ScreenType.success:
              {
                final list = controller.currentItems();
                final isList = controller.isList;
                return ListView.builder(
                  shrinkWrap: !isList,
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: isList ? Axis.vertical : Axis.horizontal,
                  itemBuilder: (context, index) {
                    return isList
                        ? _productVertical(index, list[index])
                        : _productHorizontal(index, list[index]);
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget _productVertical(int index, ProductModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductItem(model: model)),
          );
        },
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: Stack(
                  children: [
                    model.imagePaths.isEmpty
                        ? Container(
                            width: 90,
                            height: 100,
                            color: Colors.grey,
                            child: Center(
                              child: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        : Image.file(
                            File(model.imagePaths.first),
                            width: 90,
                            height: 100,
                            fit: BoxFit.cover,
                          ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: () {
                            getIt<ProductsController>().delete(model);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(model.name),
                    spaceH(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          model.price.toInt().toString(),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        spaceW(),
                        Text('دولار'),
                      ],
                    ),
                    spaceH(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[350],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        model.storeName,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productHorizontal(int index, ProductModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductItem(model: model)),
          );
        },
        child: Ink(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: Stack(
                  children: [
                    model.imagePaths.isEmpty
                        ? Container(
                            width: 100,
                            height: 120,
                            color: Colors.grey,
                            child: Center(
                              child: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        : Image.file(
                            File(model.imagePaths.first),
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: () {
                            getIt<ProductsController>().delete(model);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              spaceH(),
              Text(model.name),
              spaceH(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.price.toInt().toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  spaceW(),
                  Text('دولار'),
                ],
              ),
              spaceH(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[350],
                ),
                padding: const EdgeInsets.all(6),
                child: Text(
                  model.storeName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget spaceW() => SizedBox(height: 5);
  Widget spaceH() => SizedBox(height: 5);

  double maxWidth() => MediaQuery.of(context).size.width;
  double maxHeight() => MediaQuery.of(context).size.height;
}
