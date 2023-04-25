// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_http.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
    };

CreatePantryItem _$CreatePantryItemFromJson(Map<String, dynamic> json) =>
    CreatePantryItem(
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      updateLocalItem: json['updateLocalItem'] as bool,
      barcode: json['barcode'] as String,
    );

Map<String, dynamic> _$CreatePantryItemToJson(CreatePantryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'updateLocalItem': instance.updateLocalItem,
      'barcode': instance.barcode,
    };

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
    );

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
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
  Future<Product> getProductInformation(barcode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'barcode': barcode};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Product>(Options(
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
    final value = Product.fromJson(_result.data!);
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
