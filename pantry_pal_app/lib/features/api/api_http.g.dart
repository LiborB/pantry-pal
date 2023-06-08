// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_http.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMember _$AddMemberFromJson(Map<String, dynamic> json) => AddMember(
      email: json['email'] as String,
    );

Map<String, dynamic> _$AddMemberToJson(AddMember instance) => <String, dynamic>{
      'email': instance.email,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
    };

UpdatePantryItem _$UpdatePantryItemFromJson(Map<String, dynamic> json) =>
    UpdatePantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      barcode: json['barcode'] as String,
      updateLocalItem: json['updateLocalItem'] as bool,
    );

Map<String, dynamic> _$UpdatePantryItemToJson(UpdatePantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'barcode': instance.barcode,
      'updateLocalItem': instance.updateLocalItem,
    };

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
      barcode: json['barcode'] as String,
    );

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
      'barcode': instance.barcode,
    };

HouseholdMember _$HouseholdMemberFromJson(Map<String, dynamic> json) =>
    HouseholdMember(
      userId: json['userId'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$HouseholdMemberToJson(HouseholdMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'status': _$MemberStatusEnumMap[instance.status]!,
    };

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.accepted: 'accepted',
};

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      members: (json['members'] as List<dynamic>)
          .map((e) => HouseholdMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'members': instance.members,
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
  Future<Product> getProductInformation(String barcode) async {
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
  Future<dynamic> createPantryItem(UpdatePantryItem item) async {
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
  Future<dynamic> updatePantryItem(UpdatePantryItem item) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(item.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PATCH',
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

  @override
  Future<UserSettings> getUserSettings() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UserSettings>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/settings',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserSettings.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> addMember(AddMember body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/user/members',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
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
