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
  Future<Product> getProductInformation(@Query("barcode") String barcode);

  @POST("/pantry")
  Future createPantryItem(@Body() UpdatePantryItem item);

  @PATCH("/pantry")
  Future updatePantryItem(@Body() UpdatePantryItem item);

  @GET("/pantry")
  Future<List<PantryItem>> getPantryItems();

  @POST("/user")
  Future addUser();

  @GET("/user/members")
  Future<List<HouseholdMember>> getHouseholdMembers();

  @POST("/user/members")
  Future addMember(@Body() AddMember body);
}

@JsonSerializable()
class AddMember {
  String email;

  AddMember({required this.email});

  toJson() => _$AddMemberToJson(this);
}

@JsonSerializable()
class Product {
  String name;

  Product({required this.name});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
@CustomDateTimeConverter()
class UpdatePantryItem {
  int id;
  String name;
  DateTime expiryDate;
  String barcode;
  bool updateLocalItem;

  UpdatePantryItem({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.barcode,
    required this.updateLocalItem,
  });

  toJson() => _$UpdatePantryItemToJson(this);
}

@JsonSerializable()
@CustomDateTimeConverter()
class PantryItem {
  int id;
  String name;
  DateTime expiryDate;
  DateTime createdAt;
  String barcode;

  PantryItem({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.createdAt,
    required this.barcode,
  });

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);

  toJson() => _$PantryItemToJson(this);
}

enum MemberStatus {
  pending,
  accepted,
}

@JsonSerializable()
class HouseholdMember {
  String userId;
  String email;
  MemberStatus status;

  HouseholdMember({required this.userId, required this.email, required this.status});

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      _$HouseholdMemberFromJson(json);

  toJson() => _$HouseholdMemberToJson(this);
}
