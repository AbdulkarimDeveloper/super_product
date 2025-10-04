import 'dart:convert';

import 'package:test_project/features/products/data/models/product_enums.dart';
import 'package:test_project/models/pointx.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.imagePaths,
    required this.name,
    required this.storeName,
    required this.price,
    required this.type,
    required this.signature,
  });

  String id;
  List<String> imagePaths;
  String name;
  String storeName;
  double price;
  ProductEnums? type;
  List<Pointx> signature;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["Id"],
      name: json["Name"],
      price: json["Price"],
      storeName: json["StoreName"],
      imagePaths: List<String>.from(json["ImagePaths"]),
      type: json['Type'] == null ? null : ProductEnums.values[json['Type']],
      signature: List<Pointx>.from(
        (json["Signature"]).map((x) => Pointx.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "Price": price,
      "StoreName": storeName,
      "ImagePaths": imagePaths,
      "Type": type?.index,
      "Signature": signature.map((e) => e.toJson()).toList(),
    };
  }

  static List<ProductModel> parseFromString(String data) {
    return List<ProductModel>.from(
      json.decode(data).map((e) => ProductModel.fromJson(e)),
    );
  }

  static String parseToString(List<ProductModel> list) {
    return json.encode(list.map((e) => e.toJson()).toList());
  }
}
