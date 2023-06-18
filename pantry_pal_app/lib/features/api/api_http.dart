import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

import 'converter.dart';

part "api_http.g.dart";

@RestApi()
abstract class ApiHttp {
  factory ApiHttp() {
    final token = FirebaseAuth.instance.currentUser?.getIdToken();
    var dio = Dio(
      BaseOptions(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return _ApiHttp(dio, baseUrl: dotenv.get("API_BASE_URL"));
  }

  @GET("/product/{householdId}/detail")
  Future<Product> getProductInformation(@Path() String householdId, @Query("barcode") String barcode);

  @POST("/pantry/{householdId}")
  Future createPantryItem(@Path() String householdId, @Body() UpdatePantryItem item);

  @PATCH("/pantry/{householdId}")
  Future updatePantryItem(@Path() String householdId, @Body() UpdatePantryItem item);

  @GET("/pantry/{householdId}")
  Future<List<PantryItem>> getPantryItems(@Path() String householdId);

  @POST("/user")
  Future createUser();

  @GET("/household/{householdId}/members")
  Future<List<HouseholdMember>> getHouseholdMembers(@Path() String householdId);

  @POST("/household/{householdId}/members")
  Future addHouseholdMember(@Path() String householdId, @Body() AddMember body);

  @POST("/household")
  Future createHousehold(@Body() CreateHouseholdPayload body);

  @GET("/household")
  Future<List<Household>> getHouseholds();
}

@JsonSerializable()
@CustomDateTimeConverter()
class Household {
  int id;
  String name;
  DateTime createdAt;

  Household({required this.id, required this.name, required this.createdAt});

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
}

@JsonSerializable()
class CreateHouseholdPayload {
  String name;

  CreateHouseholdPayload({required this.name});

  toJson() => _$CreateHouseholdPayloadToJson(this);
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
@CustomDateTimeConverter()
class HouseholdMember {
  String userId;
  String email;
  bool isOwner;
  MemberStatus status;
  DateTime createdAt;

  HouseholdMember({required this.userId, required this.email, required this.status, required this.isOwner, required this.createdAt});

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      _$HouseholdMemberFromJson(json);

  toJson() => _$HouseholdMemberToJson(this);
}
