// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_http.dart';

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

CreatePantryItem _$CreatePantryItemFromJson(Map<String, dynamic> json) =>
    CreatePantryItem(
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
    );

Map<String, dynamic> _$CreatePantryItemToJson(CreatePantryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
    };

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
    );

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiHttp implements ApiHttp {
  _ApiHttp(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ProductInformationResponse> getProductInformation(barcode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProductInformationResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/product/detail',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ProductInformationResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> createPantryItem(item) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(item.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/pantry',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<PantryItem>> getPantryItems() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<PantryItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/pantry',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => PantryItem.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
