import 'package:json_annotation/json_annotation.dart';
import '../converter.dart';

part 'pantry.g.dart';

@JsonSerializable()
class Product {
  String productName;
  String brand;
  double quantity;
  String quantityUnit;
  double energyPer100g;

  Product({required this.productName, required this.brand, required this.quantity, required this.quantityUnit, required this.energyPer100g});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
@CustomDateTimeConverter()
class UpdatePantryItem {
  int id;
  String productName;
  DateTime expiryDate;
  String barcode;
  bool updateLocalItem;
  String? brand;
  double? quantity;
  String? quantityUnit;
  double? energyPer100g;

  UpdatePantryItem({
    required this.id,
    required this.productName,
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
  String productName;
  DateTime expiryDate;
  DateTime createdAt;
  String barcode;
  String? brand;
  double? quantity;
  String? quantityUnit;
  double? energyPer100g;

  PantryItem({
    required this.id,
    required this.productName,
    required this.expiryDate,
    required this.createdAt,
    required this.barcode,
    required this.brand,
    required this.quantity,
    required this.quantityUnit,
    required this.energyPer100g,
  });

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);

  toJson() => _$PantryItemToJson(this);
}