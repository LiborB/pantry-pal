// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productName: json['productName'] as String,
      brand: json['brand'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      quantityUnit: json['quantityUnit'] as String,
      energyPer100g: (json['energyPer100g'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productName': instance.productName,
      'brand': instance.brand,
      'quantity': instance.quantity,
      'quantityUnit': instance.quantityUnit,
      'energyPer100g': instance.energyPer100g,
    };

UpdatePantryItem _$UpdatePantryItemFromJson(Map<String, dynamic> json) =>
    UpdatePantryItem(
      id: json['id'] as int,
      productName: json['productName'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      barcode: json['barcode'] as String,
      updateLocalItem: json['updateLocalItem'] as bool,
    )
      ..brand = json['brand'] as String?
      ..quantity = (json['quantity'] as num?)?.toDouble()
      ..quantityUnit = json['quantityUnit'] as String?
      ..energyPer100g = (json['energyPer100g'] as num?)?.toDouble();

Map<String, dynamic> _$UpdatePantryItemToJson(UpdatePantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'barcode': instance.barcode,
      'updateLocalItem': instance.updateLocalItem,
      'brand': instance.brand,
      'quantity': instance.quantity,
      'quantityUnit': instance.quantityUnit,
      'energyPer100g': instance.energyPer100g,
    };

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
      id: json['id'] as int,
      productName: json['productName'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
      barcode: json['barcode'] as String,
      brand: json['brand'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantityUnit: json['quantityUnit'] as String?,
      energyPer100g: (json['energyPer100g'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
      'barcode': instance.barcode,
      'brand': instance.brand,
      'quantity': instance.quantity,
      'quantityUnit': instance.quantityUnit,
      'energyPer100g': instance.energyPer100g,
    };
