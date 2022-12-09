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

class ApiService {
  static Future<ProductInformationResponse> getProductInformation(
      String barcode) async {
    final response = await ApiHttp.get("/product/detail", {"barcode": barcode});
    return ProductInformationResponse.fromJson(response);
  }
}
