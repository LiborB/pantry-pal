import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:pantry_pal/shared/api_http.dart';

part 'api_service.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "product_name")
  String productName;

  @JsonKey(name: "image_url")
  String imageUrl;

  Product({required this.productName, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class ProductInformationResponse {
  Product product;

  ProductInformationResponse({required this.product});

  factory ProductInformationResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductInformationResponseFromJson(json);
}

class CreatePantryItem {
  String name;
  DateTime? expiryDate;

  CreatePantryItem({required this.name, this.expiryDate});
}

@JsonSerializable()
class PantryItem {
  int id;
  String name;
  DateTime? expiryDate;

  PantryItem({required this.id, required this.name, this.expiryDate});

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);
}

class PantryService {
  static Future<ProductInformationResponse> getProductInformation(
      String barcode) async {
    final response = await ApiHttp.get("/product/detail",
        queryParameters: {"barcode": barcode});
    return ProductInformationResponse.fromJson(response);
  }

  static Future createPantryItem(CreatePantryItem item) async {
    await ApiHttp.post("/pantry", {"name": item.name});
  }

  static Future<List<PantryItem>> getPantryItems() async {
    List response = await ApiHttp.get("/pantry");

    return response
        .map((pantryItem) => PantryItem.fromJson(pantryItem))
        .toList();
  }
}
