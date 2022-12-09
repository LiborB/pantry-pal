// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productName: json['product_name'] as String,
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_name': instance.productName,
      'image_url': instance.imageUrl,
    };

ProductInformationResponse _$ProductInformationResponseFromJson(
        Map<String, dynamic> json) =>
    ProductInformationResponse(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductInformationResponseToJson(
        ProductInformationResponse instance) =>
    <String, dynamic>{
      'product': instance.product,
    };
