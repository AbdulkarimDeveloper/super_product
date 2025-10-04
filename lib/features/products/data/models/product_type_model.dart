import 'package:test_project/features/products/data/models/product_enums.dart';

class ProductTypeModel {
  ProductTypeModel({required this.name, required this.type});
  String name;
  ProductEnums type;

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      name: json["Name"],
      type: ProductEnums.values[json['Type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {"Name": name, "Type": type.index};
  }
}
