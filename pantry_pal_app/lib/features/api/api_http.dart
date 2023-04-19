import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pantry_pal/shared/globals.dart';
import 'package:retrofit/http.dart';

import 'converter.dart';

part "api_http.g.dart";

@RestApi()
abstract class ApiHttp {
  factory ApiHttp() {
    var dio = Dio(
      BaseOptions(
        headers: {"Authorization": "Bearer $currentUserToken"},
      ),
    );

    return _ApiHttp(dio, baseUrl: dotenv.get("API_BASE_URL"));
  }

  @GET("/product/detail")
  Future<ProductInformationResponse> getProductInformation(String barcode);

  @POST("/pantry")
  Future createPantryItem(@Body() CreatePantryItem item);

  @GET("/pantry")
  Future<List<PantryItem>> getPantryItems();
}

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

@JsonSerializable()
@CustomDateTimeConverter()
class CreatePantryItem {
  String name;
  DateTime expiryDate;

  CreatePantryItem({required this.name, required this.expiryDate});

  Map<String, dynamic> toJson() => _$CreatePantryItemToJson(this);
}

@JsonSerializable()
@CustomDateTimeConverter()
class PantryItem {
  int id;
  String name;
  DateTime expiryDate;

  PantryItem({required this.id, required this.name, required this.expiryDate});

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);
}
