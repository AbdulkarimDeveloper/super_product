import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:test_project/components/general_drop_down_text_filed.dart';
import 'package:test_project/features/products/data/models/product_enums.dart';
import 'package:test_project/features/products/data/models/product_model.dart';
import 'package:test_project/features/products/presentation/controllers/products_controller.dart';
import 'package:test_project/helpers/image_picker_helper.dart';
import 'package:test_project/injections.dart';
import 'package:test_project/models/pointx.dart';
import 'package:test_project/toast/success_toast.dart';
import 'package:test_project/utils/context_extension.dart';
import 'package:test_project/utils/generate_ids.dart';
import 'package:test_project/widgets/signature.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, this.model});

  final ProductModel? model;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _storeNameController;
  late SignatureController _signatureController;
  List<String> images = [];
  String id = '';
  ProductEnums? type;

  @override
  void initState() {
    _signatureController = SignatureController(
      points: widget.model?.signature
          .map(
            (e) => Point(
              Offset(e.dx, e.dy),
              e.type.name == PointType.move.name
                  ? PointType.move
                  : PointType.tap,
              e.pressure,
            ),
          )
          .toList(),
    );
    _nameController = TextEditingController(text: widget.model?.name);
    _priceController = TextEditingController(
      text: widget.model?.price.toInt().toString(),
    );
    _storeNameController = TextEditingController(text: widget.model?.storeName);
    images = widget.model?.imagePaths ?? [];
    id = widget.model?.id ?? generateUId();
    type = widget.model?.type;
    super.initState();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _priceController.dispose();
    _storeNameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //------------------ * Title * ------------------//
                _title(),
                spaceH(),
                //------------------ * Images * ------------------//
                _listImagesProduct(),
                spaceH(),
                //------------------ * Add Image Button * ------------------//
                _cardBox(),
                spaceH(),
                //------------------ * Product Name * ------------------//
                _fieldData('اسم المنتج', _nameController),
                spaceH(),
                //------------------ * Store Name * ------------------//
                _fieldData('اسم المتجر', _storeNameController),
                spaceH(),
                //------------------ * Price * ------------------//
                _fieldData('السعر', _priceController, true),
                spaceH(),
                //------------------ * Type * ------------------//
                _type(),
                spaceH(),
                //------------------ * Signature * ------------------//
                _signature(),
                spaceH(),
                spaceH(),
                spaceH(),
                //------------------ * Create/Update Button * ------------------//
                _addEditProductCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text('صور المنتج');
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        '${widget.model == null ? 'اضافة' : 'تعديل'} منتج',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey[200],
      shadowColor: Colors.transparent,
      centerTitle: true,
      leading: boxAppBar(),
    );
  }

  Widget boxAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.pop(context);
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_outlined, size: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listImagesProduct() {
    return SizedBox(
      width: context.maxWidth,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _listImagesProductItem(index, images[index]);
        },
      ),
    );
  }

  Widget _listImagesProductItem(int index, String image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: Image.file(
                File(image),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Icon(Icons.clear, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardBox() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final image = await ImagePickerHelper.instance.pick(
          source: ImageSource.gallery,
        );
        if (image != null) {
          setState(() {
            images.add(image.path);
          });
        }
      },
      child: Ink(
        width: context.maxHeight,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.add, color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget _addEditProductCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        makeAction();
      },
      child: Ink(
        width: context.maxHeight,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${widget.model == null ? 'اضافة' : 'تعديل'} المنتج',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _fieldData(
    String text,
    TextEditingController controller, [
    bool isPrice = false,
  ]) {
    return SizedBox(
      width: context.maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          SizedBox(height: 2),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            keyboardType: isPrice ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hint: Text(text, style: TextStyle(color: Colors.grey[400])),
              fillColor: Colors.white,
              focusColor: Colors.green,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _type() {
    return SizedBox(
      width: context.maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('التصنيف'),
          SizedBox(height: 2),
          SizedBox(
            width: context.maxWidth,
            height: 60,
            child: SizedBox(
              child: GeneralDropDownTextFiled<ProductEnums>(
                isDense: false,
                hintText: 'اسم التصنيف',
                isExpanded: true,
                rad: 10,
                subfixIcon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.blue,
                ),
                showLabel: false,
                value: type,
                list: ProductEnums.values,
                getLabel: (p0) => p0.trans,
                onChange: (p0) {
                  setState(() {
                    type = p0;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _signature() {
    return SignatureWidget(signatureController: _signatureController);
  }

  Widget spaceW() => SizedBox(height: 5);
  Widget spaceH() => SizedBox(height: 5);

  makeAction() async {
    // final points = compressPoints(_signatureController.points);
    List<Pointx> signature = _signatureController.points
        .map(
          (e) => Pointx(
            dx: e.offset.dx,
            dy: e.offset.dy,
            type: e.type.name == PointxType.move.name
                ? PointxType.move
                : PointxType.tap,
            pressure: e.pressure,
          ),
        )
        .toList();

    final model = ProductModel(
      id: id,
      imagePaths: images,
      name: _nameController.text,
      storeName: _storeNameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      signature: signature,
      type: type,
    );

    bool res = false;
    String message = 'تم _args المنتج بنجاح';
    if (widget.model == null) {
      res = await getIt<ProductsController>().add(model);
    } else {
      res = await getIt<ProductsController>().update(model);
    }

    if (res) {
      context.pop();
      message = message.replaceAll(
        '_args',
        widget.model == null ? 'اضافة' : 'تعديل',
      );
      showSuccessFlashBar(message);
    }
  }
}
