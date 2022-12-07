import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductInformationResponse {
  String productName;

  ProductInformationResponse({required this.productName});

  factory ProductInformationResponse.fromJSON(Map<String, dynamic> json) {
    return ProductInformationResponse(productName: json["product_name"]);
  }
}

class ApiService {
  static final _baseUrl = "${dotenv.env["API_BASE_URL"]}/pantry";

  static Future<ProductInformationResponse> getProductInformation(
      String barcode) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail"));

    if (response.statusCode == 200) {
      return ProductInformationResponse.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception("Failed to find product information");
    }
  }
}
